// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:html/parser.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'windows_1251.dart';

class FileManager {
  FileManager._();

  static final FileManager instance = FileManager._();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> write({required String filename, required String data}) async {
    final path = await _localPath;
    final file = File('$path/$filename');
    return file.writeAsString(data);
  }
}

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final Dio dio = Dio();

  final Map<String, dynamic> headers = {
    'User-Agent':
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:50.0) Gecko/20100101 Firefox/50.0',
    'Accept-Language': 'en-us;q=0.5,en;q=0.3',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
  };

  void logInDio(String phone, String password) async {
    dio.options.headers = headers;
    headers['Referer'] =
        'https://m.vk.com/login?role=fast&to=&s=1&m=1&email=$phone';

    Map<String, String> payload = {'email': phone, 'pass': password};
    String uri = 'https://m.vk.com/login';

    String? action;
    try {
      final response = await dio.get(uri, options: Options(headers: headers));
      print(response.headers);
      updateCookie(response.headers.map['set-cookie']!.join(','));
      if (response.statusCode == 200) {
        var document = parse(response.data);
        FileManager.instance.write(filename: 'login.html', data: response.data);
        action = document.getElementsByTagName('form')[0].attributes['action'];
        print(action);
      }
    } catch (e) {
      print(e);
    }
    if (action != null) {
      var params = Map.fromEntries(action
          .substring(action.indexOf('?') + 1)
          .split('&')
          .map((e) => MapEntry(e.substring(0, e.indexOf('=')),
              e.substring(e.indexOf('=') + 1))));
      action = action.substring(0, action.indexOf('?'));
      print(action);
      //params['_origin'] = 'https://m.vk.com';
      print(params);
      final response = await dio.post(action,
          queryParameters: params,
          data: FormData.fromMap(payload),
          options: Options(
              headers: headers,
              validateStatus: (status) {
                if (status != null) {
                  return status < 500;
                }
                return false;
              }));
      if (response.statusCode == 302) {
        print(response.headers);
      }
    }
  }


  void updateCookie(String? rawCookie) {
    if (rawCookie == null) return;
    rawCookie = rawCookie.replaceAll(', ', '###');
    Map<String, String> _newCookie = {};
    List<String> lst = rawCookie.split(',');
    for (String e in lst) {
      var cookie = Cookie.fromSetCookieValue(e.replaceAll('###', ', '));
      print('${cookie.name} = ${cookie.value}');
      if (cookie.value != 'DELETED') {
        _newCookie[cookie.name] = cookie.value;
      } else {
        _newCookie.remove(cookie.name);
      }
    }

    Map<String, String> _oldCookie = {};
    dio.options.headers['cookie']?.trim().split(';').forEach((pair) {
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
      if (value != 'DELETED') {
        cookie.add('$key=$value');
      }
    });

    dio.options.headers['cookie'] = cookie.join('; ');
    print('Updated cookies: $headers');
  }

  /*
  void logIn(String phone, String password) async {
    headers['Referer'] =
        'https://m.vk.com/login?role=fast&to=&s=1&m=1&email=$phone';

    Map<String, String> payload = {'email': phone, 'pass': password};
    String uri = 'https://m.vk.com/login';

    String? action;
    try {
      final response = await http.get(Uri.parse(uri));
      updateCookie(response.headers['set-cookie']);
      if (response.statusCode == 200) {
        var document = parse(response.body);
        FileManager.instance.write(filename: 'login.html', data: response.body);
        action = document.getElementsByTagName('form')[0].attributes['action'];
        print(action);
      }
    } catch (e) {
      print(e);
    }

    if (action != null) {
      try {
        final response =
            await http.post(Uri.parse(action), body: payload, headers: headers);
        updateCookie(response.headers.entries.map((entity) => '${entity.key}=${entity.value}').join(','));
        if (response.statusCode == 302) {
          print(response.headers['location']);
          var resp = await http.get(Uri.parse('https://vk.com/bytes7bytes7'),
              headers: headers);
          FileManager.instance.write(filename: 'profile.html', data: resp.body);
          resp = await http.post(Uri.parse(response.headers['location']!));
          updateCookie(resp.headers.entries.map((entity) => '${entity.key}=${entity.value}').join(', '));
          print(resp.statusCode);
          print(resp.headers);
          print(resp.body);
          String feed = 'https://m.vk.com/feed';
          final r = await http.get(Uri.parse('https://m.vk.com/feed'));
          updateCookie(r.headers.entries.map((entity) => '${entity.key}=${entity.value}').join(', '));
          FileManager.instance.write(filename: 'feed.html', data: r.body);
        }
      } catch (e) {
        print(e);
      }
    }
  }

   */
}
