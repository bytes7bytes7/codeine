// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import '../services/win1251_decoder.dart';
import '../database/database_helper.dart';
import '../models/user.dart';
import '../constants.dart';
import '../global/global_parameters.dart';

class Session {
  Map<String, String> headers = Map.from(ConstantHTTP.headers);

  Future<Map> get(String url) async {
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    updateCookie(response);
    return json.decode(response.body);
  }

  Future<Map> post(String url, dynamic data) async {
    http.Response response = await http.post(Uri.parse(url), body: data, headers: headers);
    updateCookie(response);
    return json.decode(response.body);
  }

  void updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'] ?? '';
    if (rawCookie.isNotEmpty) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
      (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}

abstract class AuthService {
  static String _hash = '';
  static String captchaSID = '';

  static Future<AuthStatus> fetchUserData() async {
    if (User.id != null) {
      await DatabaseHelper.db.getUser(User.id!);
      if (User.phoneOrEmail != null) {
        return AuthStatus.loggedIn;
      }
      Response response;
      try {
        response = await User.dio!.get(
          '${ConstantHTTP.vkURL}id${User.id}',
          options:
              Options(responseType: ResponseType.bytes, followRedirects: false),
        );
      } on DioError catch (e) {
        if (GlobalParameters.connectionStatus.value ==
            ConnectivityResult.none) {
          return AuthStatus.noInternet;
        } else {
          print('logIn error: ${e.error}');
          print('logIn error: ${e.message}');
          print('logIn error: ${e.type}');
          return AuthStatus.unknownError;
        }
      }

      String data = response.data.toString();
      AuthStatus status = AuthStatus.loggedIn;
      String start = '';
      utf8
          .encode(
              '<form method="POST" name="login" id="quick_login_form" action="https://login.vk.com/?act=login">')
          .forEach((byte) {
        start += byte.toString() + ', ';
      });
      if (data.contains(start)) {
        status = AuthStatus.loggedOut;
      } else {
        await _setUserData(data);
      }
      return status;
    }
    return AuthStatus.loggedOut;
  }

  static Future<AuthStatus> checkCookie() async {
    if (User.cookieJar!.hostCookies.isNotEmpty) {
      var trash = User.cookieJar!.hostCookies;
      print(trash.toString());
      print('User.cookieJar domains is NOT empty');
      String uid;
      try {
        // TODO: replace it
        uid = '';
        //uid = User.cookieJar!.hostCookies[0]['login.vk.com']['/']['l'].toString();

        User.id =
            int.parse(uid.substring(uid.indexOf('l=') + 2, uid.indexOf(';')));
        print(User.id);
      } catch (e) {
        print('checkCookie error');
        return AuthStatus.errorCookies;
      }

      //Load header to User.dio client
      Map<String, String> headers = HashMap();
      headers.addAll(ConstantHTTP.headers);
      User.dio!.options.headers = headers;
      if (User.cookieJar!.hostCookies.isNotEmpty) {
        String cookies = headers['cookie']!;
        Map<dynamic, dynamic> domains;

        // TODO: replace it
        domains = HashMap();
        //domains = HashMap.from(User.cookieJar.hostCookies![0]['vk.com']['/']);


        for (int i = 0; i < domains.keys.length; i++) {
          String key = domains.keys.toList()[i].toString();
          String value = domains[key].toString();
          value = value.substring(value.indexOf(key));
          value = value.substring(0, value.indexOf(';'));
          // if (key == 'remixuas' || key == 'remixtmr_login')
          //   continue;
          // else if (key == 'remixsid') value = key + '=DELETED';
          cookies += value + '; ';
        }
        cookies = cookies.substring(0, cookies.length - 2);
        //cookies += '; '+ 'remixbdr=0';
        User.dio!.options.headers['cookie'] = cookies;
        print(User.dio!.options.headers['cookie']);
      }
      return AuthStatus.cookies;
    }
    print('no cookies');
    return AuthStatus.noCookies;
  }

  static void _updateCookie(Response response) {
    List<String> setCookie = response.headers['set-cookie']!;
    Map<String, String> cookie = {};
    String key, value;
    for (String line in setCookie) {
      key = line.substring(0, line.indexOf('='));
      value = line.substring(line.indexOf('=') + 1, line.indexOf(';'));
      cookie.putIfAbsent(key, () => value);
      // cookie[key] = value;
    }
    Map<String, String> oldCookie = {};
    User.dio!.options.headers['cookie'].trim().split(';').forEach((pair) {
      if (pair.isNotEmpty) {
        pair = pair.trim();
        String key = pair.substring(0, pair.indexOf('=')),
            value = pair.substring(pair.indexOf('=') + 1);
        oldCookie[key] = value;
      }
    });

    cookie['remixbdr'] = '0';

    oldCookie.addAll(cookie);

    List<String> newCookie = [];
    oldCookie.forEach((key, value) {
      if (value != 'DELETED') {
        newCookie.add('$key=$value');
      }
    });

    Map<String, dynamic> headers =
        Map<String, dynamic>.from(User.dio!.options.headers);
    headers['cookie'] = newCookie.join('; ');

    User.dio!.options.headers = Map<String, dynamic>.from(headers);
  }

  static Future<void> _setUserData(String data) async {
    String start = '', end = '';

    // Get Json from html
    utf8.encode('{Notifier.init(').forEach((byte) {
      start += byte.toString() + ', ';
    });

    data = data.substring(data.indexOf(start) + start.length);

    utf8.encode('if (window').forEach((byte) {
      end += byte.toString() + ', ';
    });

    data = data.substring(0, data.indexOf(end));

    end = '';
    utf8.encode(')}').forEach((byte) {
      end += byte.toString() + ', ';
    });
    data = data.substring(0, data.lastIndexOf(end)).replaceAll(' ', '');

    if (data.endsWith(',')) {
      data = data.substring(0, data.length - 1);
    }

    List<String> bytesStr = data.split(',');
    bytesStr = bytesStr.map<String>((e) => e.trim()).toList();
    Iterable<int> bytes = bytesStr.map<int>((e) => int.parse(e));

    // Convert windows1251 bytes to string
    data = Win1251Decoder.decode(bytes);
    Map<String, dynamic> jsonData = json.decode(data);

    User.id = jsonData['callsCredentials']['me']['peerId'];
    User.link = jsonData['callsCredentials']['me']['link'];
    User.name = jsonData['callsCredentials']['me']['name'];
    User.firstName = jsonData['callsCredentials']['me']['firstName'];
    User.lastName = jsonData['callsCredentials']['me']['lastName'];
    User.shortName = jsonData['callsCredentials']['me']['shortName'];
    User.sex = int.parse(jsonData['callsCredentials']['me']['sex']);
    User.photo = jsonData['callsCredentials']['me']['photo'];
    User.photo_100 = jsonData['callsCredentials']['me']['photo_100'];

    await DatabaseHelper.db.updateUser();
  }

  static _firstPostLoginVk(
      FormData formData, Map<String, String> queryParameters) async {
    Response response;
    try {
      response = await User.dio!.post(
        ConstantHTTP.vkLoginURL,
        queryParameters: queryParameters,
        data: formData,
        options: Options(
          followRedirects: true,
          validateStatus: (status) {
            if (status != null) {
              return status < 500;
            } else {
              return true;
            }
          },
        ),
      );
    } on DioError catch (e) {
      if (GlobalParameters.connectionStatus.value == ConnectivityResult.none) {
        return AuthStatus.noInternet;
      } else {
        print('logIn error: ${e.error}');
        print('logIn error: ${e.message}');
        print('logIn error: ${e.type}');
        return AuthStatus.unknownError;
      }
    }

    _updateCookie(response);

    return response;
  }

  // TODO: try to implement all request with http package
  // static Future<AuthStatus> logInHttp(String phone, String password)async{
  //   User.phoneOrEmail = phone;
  //   Session session = Session();
  //
  //   try {
  //     Map body = await session.get(ConstantHTTP.vkURL);
  //   } on DioError catch (e) {
  //     if (GlobalParameters.connectionStatus.value == ConnectivityResult.none) {
  //       return AuthStatus.noInternet;
  //     } else {
  //       print('logIn error: ${e.error}');
  //       print('logIn error: ${e.message}');
  //       print('logIn error: ${e.type}');
  //       return AuthStatus.unknownError;
  //     }
  //   }
  //   return AuthStatus.unknownError;
  // }

  static Future<AuthStatus> logIn(String phone, String password) async {
    User.cookieJar!.deleteAll();

    User.phoneOrEmail = phone;
    User.dio!.options.headers = ConstantHTTP.headers;
    User.cookieJar!.loadForRequest(Uri.parse(ConstantHTTP.vkLoginURL));
    Response response;

    try {
      response = await User.dio!.get(ConstantHTTP.vkURL);
    } on DioError catch (e) {
      if (GlobalParameters.connectionStatus.value == ConnectivityResult.none) {
        return AuthStatus.noInternet;
      } else {
        print('logIn error: ${e.error}');
        print('logIn error: ${e.message}');
        print('logIn error: ${e.type}');
        return AuthStatus.unknownError;
      }
    }
    // TODO: In this response there are 2 remixlhk

    _updateCookie(response);

    // Get form data
    var document = parse(response.data);
    var parameters = document
        .getElementById("quick_login_form")!
        .getElementsByTagName('input');
    Map<String, String> forms = HashMap();
    for (var p in parameters) {
      if (p.attributes['value'] != null) {
        forms[p.attributes['name']!] = p.attributes['value']!;
      }
    }
    forms['to'] = 'bG9naW4/bT0xJmVtYWlsPWFzJnRvPWFXNWtaWGd1Y0dodw--';
    forms['email'] = phone;
    forms['pass'] = password;

    // 1st request
    var formData = FormData.fromMap(forms);
    dynamic result = await _firstPostLoginVk(formData, {'act': 'login'});
    if (result is Response) {
      response = result;
    } else {
      return result;
    }

    // Make new cookies
    Map<String, String> newCookies = {
      'remixbdr': '0',
      'remixlang': '0',
    };

    User.dio!.options.headers['cookie'].split(';').forEach((line) {
      if (line.isNotEmpty) {
        line = line.trim();
        String key = line.substring(0, line.indexOf('='));
        String value = line.substring(line.indexOf('=') + 1);
        newCookies.addAll({key: value});
      }
    });

    List<String> cookieList = [];
    newCookies.forEach((key, value) {
      cookieList.add('$key=$value');
    });

    Map<String, dynamic> headers =
        Map<String, dynamic>.from(User.dio!.options.headers);
    headers['cookie'] = cookieList.join('; ');

    User.dio!.options.headers = Map<String, dynamic>.from(headers);

    // Separate uri from parameters
    String location = response.headers['location']!.first;
    Map<String, String> queryParams = {};

    List<String> params =
        location.substring(location.indexOf('?') + 1).split('&');
    location = location.substring(0, location.indexOf('?'));

    for (var element in params) {
      List<String> keyValue = element.split('=');
      queryParams.putIfAbsent(keyValue[0], () => keyValue[1]);
    }

    queryParams['to'] = 'aW5kZXgucGhw';

    // 2nd request
    try {
      response = await User.dio!.get(
        location,
        queryParameters: queryParams,
        options: Options(responseType: ResponseType.bytes),
      );
    } on DioError catch (e) {
      if (GlobalParameters.connectionStatus.value == ConnectivityResult.none) {
        return AuthStatus.noInternet;
      } else {
        print('logIn error: ${e.error}');
        print('logIn error: ${e.message}');
        print('logIn error: ${e.type}');
        return AuthStatus.unknownError;
      }
    }
    _updateCookie(response);

    String data = response.data.toString();
    // Check if login was successful
    AuthStatus status;
    String start = '';
    utf8.encode('onLoginDone').forEach((byte) {
      start += byte.toString() + ', ';
    });
    if (!data.contains(start)) {
      start = '';
      utf8.encode('/login?act=authcheck').forEach((byte) {
        start += byte.toString() + ', ';
      });
      if (!data.contains(start)) {
        print('Login failed');
        status = AuthStatus.loggedOut;
      } else {
        // Need to confirm the code
        print('Confirmation code');
        status = AuthStatus.needCode;
      }
    } else {
      print('Login done');
      status = AuthStatus.loggedIn;
      await _setUserData(data);
      print(await User.cookieJar?.loadForRequest(Uri.parse('login.vk.com')));
      print(await User.cookieJar?.loadForRequest(Uri.parse('vk.com')));
    }

    return status;
  }

  static Future<AuthStatus> getCode() async {
    Map<String, String> queryParams = {
      'act': 'authcheck',
    };

    Response response;
    try {
      response = await User.dio!.get(
        '${ConstantHTTP.vkURL}login',
        queryParameters: queryParams,
        options: Options(responseType: ResponseType.bytes),
      );
    } on DioError catch (e) {
      if (GlobalParameters.connectionStatus.value == ConnectivityResult.none) {
        return AuthStatus.noInternet;
      } else {
        print('logIn error: ${e.error}');
        print('logIn error: ${e.message}');
        print('logIn error: ${e.type}');
        return AuthStatus.unknownError;
      }
    }
    _updateCookie(response);
    String data = response.data.toString();

    String start = '', end = '';
    utf8.encode("window.Authcheck.init('").forEach((byte) {
      start += byte.toString() + ', ';
    });

    data = data.substring(data.indexOf(start) + start.length);

    end = '';
    utf8.encode("'").forEach((byte) {
      end += byte.toString() + ', ';
    });
    data = data.substring(0, data.lastIndexOf(end));

    // "hash" parameter for the next request's form data
    List<int> bytes = [];
    data = data.trim();
    data.split(',').forEach((byte) {
      byte = byte.trim();
      if (byte.isNotEmpty) {
        bytes.add(int.parse(byte));
      }
    });
    _hash = utf8.decode(bytes);
    return AuthStatus.ok;
  }

  static Future<AuthStatus> confirmCode(String code) async {
    Map<String, String> forms = HashMap();

    forms['al'] = '1';
    forms['code'] = code;
    forms['hash'] = _hash;
    forms['remember'] = '1';

    var formData = FormData.fromMap(forms);
    Response response;
    try {
      response = await User.dio!.post(
        '${ConstantHTTP.vkURL}al_login.php',
        queryParameters: {'act': 'a_authcheck_code'},
        data: formData,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (status) {
            if (status != null) {
              return status < 500;
            } else {
              return true;
            }
          },
        ),
      );
    } on DioError catch (e) {
      if (GlobalParameters.connectionStatus.value == ConnectivityResult.none) {
        return AuthStatus.noInternet;
      } else {
        print('logIn error: ${e.error}');
        print('logIn error: ${e.message}');
        print('logIn error: ${e.type}');
        return AuthStatus.unknownError;
      }
    }
    _updateCookie(response);

    String data = response.data.toString();
    data = data.substring(1, data.length - 1);

    List<int> bytes = [];
    data.trim().split(',').forEach((byte) {
      byte = byte.trim();
      if (byte.isNotEmpty) {
        bytes.add(int.parse(byte));
      }
    });

    String decoded = utf8.decode(bytes);
    decoded = decoded.substring(4);

    var jsonData = json.decode(decoded);
    String location = jsonData['payload'][1][0];

    // TODO: here jsonData can be smth like: {"payload":["2",["\"889784531685\"","0"]],"statsMeta":{"platform":"web2","st":false,"time":1624864729,"hash":"rr9Nqtl8ZlJzUPalJsFqVeZ5Us2xdmDdXuvstUe3QQg"},"loaderVersion":"13187849","langVersion":"7137"}
    // TODO: 889784531685 maybe captcha sid

    location = location.replaceAll('"', '');

    try {
      int.parse(location);
      captchaSID = location;
      return AuthStatus.captcha;
    } catch (error) {
      // pass
    }

    Map<String, String> queryParams = {};
    location.substring(location.indexOf('?') + 1).split('&').forEach((pair) {
      queryParams[pair.substring(0, pair.indexOf('='))] =
          pair.substring(pair.indexOf('=') + 1);
    });

    location = location.substring(0, location.indexOf('?'));
    try {
      response = await User.dio!.get(
        '${ConstantHTTP.vkURL}$location',
        queryParameters: queryParams,
        options: Options(responseType: ResponseType.bytes),
      );
    } on DioError catch (e) {
      if (GlobalParameters.connectionStatus.value == ConnectivityResult.none) {
        return AuthStatus.noInternet;
      } else {
        print('logIn error: ${e.error}');
        print('logIn error: ${e.message}');
        print('logIn error: ${e.type}');
        return AuthStatus.unknownError;
      }
    }

    _updateCookie(response);

    location = response.headers['location']!.first;

    try {
      response = await User.dio!.get(
        '${ConstantHTTP.vkURL}$location',
        queryParameters: queryParams,
        options: Options(responseType: ResponseType.bytes),
      );
    } on DioError catch (e) {
      if (GlobalParameters.connectionStatus.value == ConnectivityResult.none) {
        return AuthStatus.noInternet;
      } else {
        print('logIn error: ${e.error}');
        print('logIn error: ${e.message}');
        print('logIn error: ${e.type}');
        return AuthStatus.unknownError;
      }
    }

    _updateCookie(response);
    return AuthStatus.loggedIn;
  }

  static AuthStatus logOut() {
    User.cookieJar!.deleteAll();
    User.dio!.options.headers.clear();
    return AuthStatus.loggedOut;
  }
}