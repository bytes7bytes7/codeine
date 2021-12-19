import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'constants.dart' as constants;

enum RequestType {
  get,
  post,
}

class Session {
  Session({required bool isPersistent})
      : _dio = Dio()
          ..options.headers = Map.from(constants.headers)
          ..options.validateStatus = ((int? status) {
            if (status != null) {
              return status < 500;
            }
            return false;
          }),
        _isPersistent = isPersistent;

  final Dio _dio;
  final bool _isPersistent;

  bool get isPersistent => _isPersistent;

  Map<String, dynamic> get _defaultHeaders => Map.from(constants.headers);

  Future<File> get _persistSessionFile async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/${constants.persistent}');
  }

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
      rethrow;
    }

    _updateCookie(response);

    final redirect = await _tryFollowRedirect(response, RequestType.post, data);
    if (redirect != null) {
      return redirect;
    }
    return response;
  }

  Future<void> loadPersistentSession() async {
    final file = await _persistSessionFile;
    if (file.existsSync()) {
      _dio.options.headers = json.decode(file.readAsStringSync(encoding: utf8));
    }
  }

  Future<void> clearSession() async {
    final file = await _persistSessionFile;
    file.deleteSync();
    _dio.options.headers = _defaultHeaders;
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

    if (_isPersistent) {
      _cache();
    }
  }

  Future<Response?> _tryFollowRedirect(Response response, RequestType type,
      [Map<String, dynamic> data = const {}]) async {
    List<String>? location = response.headers.map['location'];
    if (location != null) {
      if (location[0] == '/') return null;

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

  void _cache() async {
    final file = await _persistSessionFile;
    file.writeAsString(json.encode(_dio.options.headers), encoding: utf8);
  }
}
