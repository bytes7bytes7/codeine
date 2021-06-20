import 'dart:convert';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

class User {
  static final User _singleton = User._internal();
  Dio dio;
  PersistCookieJar cookieJar;

  factory User() {
    return _singleton;
  }

  User._internal() {
    _init();
  }

  _init() async {
    dio = Dio();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    cookieJar = PersistCookieJar(dir: appDocDir.path + "./cookies/");
    dio.interceptors.add(CookieManager(cookieJar));
    dio.options.followRedirects = true;
  }

  int id;
  String link;
  String name;
  String firstName;
  String lastName;
  String shortName;
  int sex;
  String photo;
  String photo_100;
  String phoneOrEmail;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'link': link,
      'name': name,
      'firstName': firstName,
      'lastName': lastName,
      'shortName': shortName,
      'sex': sex,
      'photo': photo,
      'photo_100': photo_100,
      'phoneOrEmail': phoneOrEmail,
    };
  }

  static fromMap(Map<String, dynamic> map) {
    _singleton.id = map['id'];
    _singleton.link = map['link'];
    _singleton.name = map['name'];
    _singleton.firstName = map['firstName'];
    _singleton.lastName = map['lastName'];
    _singleton.shortName = map['shortName'];
    _singleton.sex = map['sex'];
    _singleton.photo = map['photo'];
    _singleton.photo_100 = map['photo_100'];
    _singleton.phoneOrEmail = map['phoneOrEmail'];
  }

  String toJson() => json.encode(toMap());

  fromJson(String str) => fromMap(json.decode(str));
}