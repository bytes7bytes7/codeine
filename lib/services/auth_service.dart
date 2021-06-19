import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';

import '../database_helper/database_helper.dart';
import '../models/user.dart';
import '../constants.dart';

class AuthService {
  static final User me = User();

  static Future fetchUserData() async {
    if (me.id != null) {
      await me.dio.get('${ConstantHTTP.vkURL}id${me.id}');
    }
  }

  static Future checkCookie() async {
    if (me.cookieJar.domainCookies.isNotEmpty) {
      print('me.cookieJar domains is NOT empty');
      print(me.cookieJar.DomainsKey);
      print(me.cookieJar.storage);
      print(me.cookieJar.IndexKey);
      print(me.cookieJar.persistSession);
      print(me.cookieJar.ignoreExpires);
      print(me.cookieJar.hostCookies);
      print(me.cookieJar.domainCookies);
      // Set userID
      String uid;
      try {
        uid =
            me.cookieJar.domainCookies[0]['login.vk.com']['/']['l'].toString();
      } catch (e) {
        return;
      }
      uid = uid.substring(uid.indexOf('l=') + 2);
      uid = uid.substring(0, uid.indexOf(';'));
      me.id = int.parse(uid);

      //Load header to me.dio client
      Map<String, String> headers = HashMap();
      headers.addAll(ConstantHTTP.headers);
      me.dio.options.headers = headers;
      if (me.cookieJar.domainCookies != null) {
        String cookies = headers['cookie'];
        Map<dynamic, dynamic> domains;
        domains = HashMap.from(me.cookieJar.domainCookies[0]['vk.com']['/']);
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
    }
  }

  static void showHeaders() async {
    print(me.dio.options.headers);
  }

  static Future<bool> login(String phone, String password) async {
    await me.cookieJar.deleteAll();

    me.phoneOrEmail=phone;
    me.dio.options.headers = ConstantHTTP.headers;
    me.cookieJar.loadForRequest(Uri.parse(ConstantHTTP.vkLoginURL));
    Response response = await me.dio.get(ConstantHTTP.vkURL);

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

    // Send forms
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

    me.dio.options.headers['cookie'] = newCookies.join('; ');

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

    // Try to log in
    response = await me.dio.get(location, queryParameters: queryParams);

    // TODO: decode response.data to utf-8

    String loginData = response.data.toString();
    bool success = loginData.contains('onLoginDone');

    if (success) {
      print('Login DONE!');
      try {
        String start = 'function () {Notifier.init(';
        String end = 'if (window';
        loginData = loginData.substring(
            loginData.indexOf(start) + start.length, loginData.indexOf(end));
        loginData = loginData.substring(0,loginData.lastIndexOf(')}'));

        var jsonData = json.decode(loginData);

        print(jsonData['callsCredentials']['me']);

        me.id = jsonData['callsCredentials']['me']['peerId'];
        me.link = jsonData['callsCredentials']['me']['link'];
        me.name = jsonData['callsCredentials']['me']['name'];
        me.firstName = jsonData['callsCredentials']['me']['firstName'];
        me.lastName = jsonData['callsCredentials']['me']['lastName'];
        me.shortName = jsonData['callsCredentials']['me']['shortName'];
        me.sex = int.parse(jsonData['callsCredentials']['me']['sex']);
        me.photo = jsonData['callsCredentials']['me']['photo'];
        me.photo_100 = jsonData['callsCredentials']['me']['photo_100'];
      } catch (e) {
        print(e);
        return false;
      }
      await DatabaseHelper.db.updateUser(me);
      return true;
    }
    print('Login FAILED!');
    return false;
  }
}
