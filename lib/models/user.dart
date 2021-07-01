import 'dart:convert';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

class User {
  static Dio dio;
  static PersistCookieJar cookieJar;

  init() async {
    if (dio == null || cookieJar == null) {
      await _init();
    }
  }

  _init() async {
    dio = Dio();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    cookieJar = PersistCookieJar(dir: appDocDir.path + "./cookies/");
    dio.interceptors.add(CookieManager(cookieJar));
    dio.options.followRedirects = true;
  }

  static int id;
  static String link;
  static String name;
  static String firstName;
  static String lastName;
  static String shortName;
  static int sex;
  static String photo;
  static String photo_100;
  static String phoneOrEmail;

  static Map<String, dynamic> toMap() {
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
    id = map['id'];
    link = map['link'];
    name = map['name'];
    firstName = map['firstName'];
    lastName = map['lastName'];
    shortName = map['shortName'];
    sex = map['sex'];
    photo = map['photo'];
    photo_100 = map['photo_100'];
    phoneOrEmail = map['phoneOrEmail'];
  }

  static String toJson() => json.encode(toMap());

  static fromJson(String str) => fromMap(json.decode(str));
}
