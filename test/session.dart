import 'dart:io';

import 'package:dio/dio.dart';

const Map<String, dynamic> _headers = {
  'User-Agent':
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:50.0) Gecko/20100101 Firefox/50.0',
  'Accept-Language': 'en-us;q=0.5,en;q=0.3',
  'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
};

enum RequestType {
  get,
  post,
}

class Session {
  Session()
      : _dio = Dio()
          ..options.headers = Map.from(_headers)
          ..options.validateStatus = ((int? status) {
            if (status != null) {
              return status < 500;
            }
            return false;
          });

  final Dio _dio;

  @override
  String toString() {
    return 'Session {dio: $_dio}';
  }

  void addToHeaders(Map<String, dynamic> headers) {
    _dio.options.headers.addAll(headers);
  }

  Future<Response> get(String uri) async {
    late Response response;
    try {
      response = await _dio.get(uri);
    } catch (e) {
      print('Session GET error: $e');
      rethrow;
    }

    _updateCookie(response);

    final redirect = await _tryFollowRedirect(response, RequestType.get);
    if (redirect != null) {
      return redirect;
    }
    return response;
  }

  Future<Response> post(String uri, Map<String, dynamic> data) async {
    late Response response;
    try {
      response = await _dio.post(
        uri,
        data: FormData.fromMap(data),
      );
    } catch (e) {
      print('Session POST error: $e');
      rethrow;
    }

    _updateCookie(response);

    final redirect = await _tryFollowRedirect(response, RequestType.post, data);
    if (redirect != null) {
      return redirect;
    }
    return response;
  }

  void _updateCookie(Response response) {
    String? rawCookie = response.headers.map['set-cookie']?.join(',');

    if (rawCookie == null) return;

    const separator = '#####';

    Map<String, String> _newCookie = {};
    List<String> lst = rawCookie.replaceAll(', ', separator).split(',');
    for (String e in lst) {
      var cookie = Cookie.fromSetCookieValue(e.replaceAll(separator, ', '));
      if (cookie.value != 'DELETED') {
        _newCookie[cookie.name] = cookie.value;
      } else {
        _newCookie.remove(cookie.name);
      }
    }

    Map<String, String> _oldCookie = {};
    _dio.options.headers['cookie']?.trim().split(';').forEach((pair) {
      if (pair.isNotEmpty) {
        pair = pair.trim();
        String key = pair.substring(0, pair.indexOf('=')),
            value = pair.substring(pair.indexOf('=') + 1);
        _oldCookie[key] = value;
      }
    });

    _oldCookie.addAll(_newCookie);

    List<String> cookie = [];
    _oldCookie.forEach((key, value) {
      cookie.add('$key=$value');
    });

    _dio.options.headers['cookie'] = cookie.join('; ');
  }

  Future<Response?> _tryFollowRedirect(Response response, RequestType type,
      [Map<String, dynamic> data = const {}]) async {
    List<String>? location = response.headers.map['location'];
    if (location != null) {
      print('[${response.statusCode}] location = $location');

      if (location[0] == '/') {
        print('Session redirect = \'/\'');
        return null;
      }

      int? statusCode = response.statusCode;
      if (statusCode != null) {
        if (statusCode == 303) {
          return await get(location[0]);
        } else {
          switch (type) {
            case RequestType.get:
              return await get(location[0]);
            case RequestType.post:
              return await post(location[0], data);
            default:
              return await get(location[0]);
          }
        }
      }
    }
  }
}
