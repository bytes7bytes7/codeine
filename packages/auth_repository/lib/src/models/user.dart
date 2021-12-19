import 'package:equatable/equatable.dart';

import '../constants.dart' as constants;

class User extends Equatable {
  final int id;
  final String name;
  final String avatarUrl;

  @override
  List<Object?> get props => [id, name, avatarUrl];

  @override
  String toString() => 'User {id: $id, name: $name, avatarUrl: $avatarUrl}';

  User.empty() : this.fromMap({});

  User.fromMap(Map<String, Object?> map)
      : id = map[constants.id] as int? ?? 0,
        name = map[constants.name] as String? ?? '',
        avatarUrl = map[constants.avatarUrl] as String? ?? '';
}
