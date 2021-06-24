import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';

import '../services/win1251_decoder.dart';
import '../database/database_helper.dart';
import '../models/user.dart';
import '../constants.dart';

abstract class AuthService {
  static final User me = User();

  static Future<AuthStatus> fetchUserData() async {
    if (me.id != null) {
      Response response = await me.dio.get('${ConstantHTTP.vkURL}id${me.id}',
          options: Options(responseType: ResponseType.bytes));
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
    if (me.cookieJar.domains.isNotEmpty) {
      print('me.cookieJar domains is NOT empty');
      String uid;
      try {
        uid = me.cookieJar.domains[0]['login.vk.com']['/']['l'].toString();
        me.id =
            int.parse(uid.substring(uid.indexOf('l=') + 2, uid.indexOf(';')));
        print(me.id);
      } catch (e) {
        print('checkCookie error');
        return AuthStatus.errorCookies;
      }

      //Load header to me.dio client
      Map<String, String> headers = HashMap();
      headers.addAll(ConstantHTTP.headers);
      me.dio.options.headers = headers;
      if (me.cookieJar.domains != null) {
        String cookies = headers['cookie'];
        Map<dynamic, dynamic> domains;
        domains = HashMap.from(me.cookieJar.domains[0]['vk.com']['/']);
        for (int i = 0; i < domains.keys.length; i++) {
          String key = domains.keys.toList()[i].toString();
          String value = domains[key].toString();
          value = value.substring(value.indexOf(key));
          value = value.substring(0, value.indexOf(';'));
          if (key == 'remixuas' || key == 'remixtmr_login')
            continue;
          else if (key == 'remixsid') value = key + '==DELETED';
          cookies += value + '; ';
        }
        cookies = cookies.substring(0, cookies.length - 2);
        me.dio.options.headers['cookie'] = cookies;
      }
      return AuthStatus.cookies;
    }
    print('no cookies');
    return AuthStatus.noCookies;
  }

  static Future<AuthStatus> logIn(String phone, String password) async {
    me.cookieJar.deleteAll();

    me.phoneOrEmail = phone;
    me.dio.options.headers = ConstantHTTP.headers;
    me.cookieJar.loadForRequest(Uri.parse(ConstantHTTP.vkLoginURL));
    Response response;

    try {
      response = await me.dio.get(ConstantHTTP.vkURL);
    }on DioError catch(e){
      print(e.error);
      print(e.message);
      print(e.type);
      return e.error;
    }

    // Get parameter remixstid
    List<String> fList = [],
        rawList = response.headers['set-cookie'].toString().split(',');
    rawList.forEach((element) {
      fList.addAll(element.split(';').map<String>((e) => e.trim()).toList());
    });

    Map<String, String> map = {};
    fList.forEach((element) {
      if (element.contains('=')) {
        rawList = element.split('=');
        map[rawList[0]] = rawList[1];
      }
    });

    // Get form data
    var document = parse(response.data);
    var parameters = document
        .getElementById("quick_login_form")
        .getElementsByTagName('input');
    Map<String, String> forms = HashMap();
    for (var p in parameters) {
      if (p.attributes['name'] != null) {
        forms[p.attributes['name']] = p.attributes['value'];
      }
    }
    forms['to'] = 'bG9naW4/bT0xJmVtYWlsPWFzJnRvPWFXNWtaWGd1Y0dodw--';
    forms['email'] = phone;
    forms['pass'] = password;

    // 1st request
    var formData = FormData.fromMap(forms);
    response = await me.dio.post(
      ConstantHTTP.vkLoginURL,
      queryParameters: {'act': 'login'},
      data: formData,
      options: Options(
        followRedirects: true,
        validateStatus: (status) {
          return status < 500;
        },
      ),
    );

    // Make new cookies
    List<String> newCookies = [
      'remixbdr=0',
      'remixsid=DELETED',
      'remixusid=DELETED',
      'remixstid=${map['remixstid']}',
      'remixflash=0.0.0',
      'remixscreen_width=1920',
      'remixscreen_height=1080',
      'remixscreen_dpr=1',
      'remixscreen_depth=24',
      'remixscreen_orient=1',
      'remixscreen_winzoom=1',
      'remixseenads=0',
      'remixlang=0',
      'remixlhk=DELETED',
    ];

    response.headers.forEach((name, values) {
      if (name.contains('remixq')) {
        newCookies.add(name + '=' + values.join());
      }
    });

    Map<String, dynamic> headers =
        Map<String, dynamic>.from(me.dio.options.headers);
    headers['cookie'] = newCookies.join('; ');

    me.dio.options.headers = Map<String, dynamic>.from(headers);

    // Separate uri from parameters
    String location = response.headers['location'].first;
    Map<String, String> queryParams = {};

    List<String> params =
        location.substring(location.indexOf('?') + 1).split('&');
    location = location.substring(0, location.indexOf('?'));

    params.forEach((element) {
      List<String> keyValue = element.split('=');
      queryParams.putIfAbsent(keyValue[0], () => keyValue[1]);
    });

    queryParams['to'] = 'aW5kZXgucGhw';

    // 2nd request
    response = await me.dio.get(
      location,
      queryParameters: queryParams,
      options: Options(responseType: ResponseType.bytes),
    );

    String data = response.data.toString();
    AuthStatus status;
    // Check if login was successful
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
    }

    return status;
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

    me.id = jsonData['callsCredentials']['me']['peerId'];
    me.link = jsonData['callsCredentials']['me']['link'];
    me.name = jsonData['callsCredentials']['me']['name'];
    me.firstName = jsonData['callsCredentials']['me']['firstName'];
    me.lastName = jsonData['callsCredentials']['me']['lastName'];
    me.shortName = jsonData['callsCredentials']['me']['shortName'];
    me.sex = int.parse(jsonData['callsCredentials']['me']['sex']);
    me.photo = jsonData['callsCredentials']['me']['photo'];
    me.photo_100 = jsonData['callsCredentials']['me']['photo_100'];

    await DatabaseHelper.db.updateUser(me);
  }

  static Future<AuthStatus> confirmationCode() async {
    Map<String, String> queryParams = {
      'act': 'authcheck',
    };
    Response response = await me.dio.get(
      '${ConstantHTTP.vkURL}login',
      queryParameters: queryParams,
      options: Options(responseType: ResponseType.bytes),
    );

    // https://vk.com/al_login.php?act=a_authcheck_code
    // POST
    // 200
    // Query: act: a_authcheck_code
    // Form:  al: 1
    // 		    code: 959714
    // 		    hash: 1624280078_fd9e1408d3701ac32e
    // 		    remember: 1
    Map<String, String> forms = HashMap();

    throw Exception('Unfinished function!!!');

    forms['al'] = '1';
    //forms['code'] = asdas;
    //forms['hash']= dasdas;
    // TODO: make it changeable
    forms['remember'] = '1';

    var formData = FormData.fromMap(forms);
    response = await me.dio.post(
      '${ConstantHTTP.vkURL}/al_login.php',
      queryParameters: {'act': 'a_authcheck_code'},
      data: formData,
      options: Options(
        followRedirects: true,
        validateStatus: (status) {
          return status < 500;
        },
      ),
    );
  }

  static AuthStatus logOut() {
    me.cookieJar.deleteAll();
    me.dio.options.headers.clear();
    return AuthStatus.loggedOut;
  }
}
