import 'package:dio/dio.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:html/parser.dart';
import 'package:database_helper/database_helper.dart';
import 'package:session_repository/session_repository.dart';

import 'auth_repository.dart';
import 'models/models.dart';
import 'constants.dart' as constants;

class VKAuthRepository extends AuthRepository {
  VKAuthRepository._();

  static final VKAuthRepository instance = VKAuthRepository._();

  final Session _session = Session(isPersistent: true);
  final HtmlUnescape _htmlUnescape = HtmlUnescape();

  @override
  Future<User> loadFromCache() async {
    final data = await SQLiteDatabase.instance.getNotes(constants.table);
    return User.fromMap(data[0]);
  }

  @override
  Future<User> logIn(String login, String password) async {
    _session.addToHeaders({
      'Referer': 'https://m.vk.com/login?role=fast&to=&s=1&m=1&email=$login'
    });

    final payload = {'email': login, 'pass': password};

    Response? response =
        await _makeRequest(constants.vkLoginUri, RequestType.get);
    if (response == null) {
      return User.empty();
    }

    String? action;
    if (response.statusCode == 200) {
      var document = parse(response.data);
      action = document.getElementsByTagName('form')[0].attributes['action'];
    }

    if (action != null) {
      response = await _makeRequest(action, RequestType.post, payload);
      if (response == null) {
        return User.empty();
      }
    } else {
      return User.empty();
    }

    response = await _makeRequest('https://m.vk.com/', RequestType.get);
    if (response == null) {
      return User.empty();
    }

    String begin = 'window.vk = {"id":';
    String id = response.data;
    id = id.substring(id.indexOf(begin) + begin.length);
    id = _htmlUnescape.convert(id.substring(0, id.indexOf(',')));

    begin = 'data-name="';
    String name = response.data;
    name = name.substring(name.indexOf(begin) + begin.length);
    name = _htmlUnescape.convert(name.substring(0, name.indexOf('"')));

    begin = 'data-photo="';
    String avatarUrl = response.data;
    avatarUrl = avatarUrl.substring(avatarUrl.indexOf(begin) + begin.length);
    avatarUrl =
        _htmlUnescape.convert(avatarUrl.substring(0, avatarUrl.indexOf('"')));

    try {
      int.parse(id);
    } catch (e) {
      return User.empty();
    }

    // TODO: cache

    return User.fromMap({
      constants.id: int.parse(id),
      constants.name: name,
      constants.avatarUrl: avatarUrl,
    });
  }

  @override
  Future<User> logOut() async {
    // TODO: clear cache and cookie
    _session.clearSession();
    return User.empty();
  }

  @override
  Future<User> checkAuth() async {
    await _session.loadPersistentSession();

    Response? response =
        await _makeRequest(constants.vkLoginUri, RequestType.get);
    if (response == null) {
      return User.empty();
    }

    String begin = 'window.vk = {"id":';
    String id = response.data;
    id = id.substring(id.indexOf(begin) + begin.length);
    id = _htmlUnescape.convert(id.substring(0, id.indexOf(',')));

    begin = 'data-name="';
    String name = response.data;
    name = name.substring(name.indexOf(begin) + begin.length);
    name = _htmlUnescape.convert(name.substring(0, name.indexOf('"')));

    begin = 'data-photo="';
    String avatarUrl = response.data;
    avatarUrl = avatarUrl.substring(avatarUrl.indexOf(begin) + begin.length);
    avatarUrl =
        _htmlUnescape.convert(avatarUrl.substring(0, avatarUrl.indexOf('"')));

    try {
      int.parse(id);
    } catch (e) {
      return User.empty();
    }

    return User.fromMap({
      constants.id: int.parse(id),
      constants.name: name,
      constants.avatarUrl: avatarUrl,
    });
  }

  Future<void> _cache() async {}

  Future<Response?> _makeRequest(String url, RequestType type,
      [Map<String, String> payload = const {}]) async {
    Response? response;
    try {
      if (type == RequestType.get) {
        response = await _session.get(url);
      } else if (type == RequestType.post) {
        response = await _session.post(url, payload);
      } else {
        throw Exception('Unknown RequestType: $type');
      }
    } catch (e) {
      rethrow;
    }
    return response;
  }
}
