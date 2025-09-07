import 'package:smart_learn/features/user/domain/entities/user_entity.dart';

abstract class PARUser {}

class PARUserAdd extends PARUser {
  final String name;
  final int age;
  final String? email;
  final String? avatar;
  final String? bio;
  final String grade;
  final String hobbies;

  PARUserAdd({
    required this.name,
    required this.age,
    this.email,
    this.avatar,
    this.bio,
    required this.grade,
    required this.hobbies,
  });
}

class PARUserUpdate extends PARUser {
  final ENTUser user;

  final String? name;
  final int? age;
  final String? email;
  final String? avatar;
  final String? bio;
  final String? grade;
  final String? hobbies;

  PARUserUpdate(
    this.user, {
    this.name,
    this.age,
    this.email,
    this.avatar,
    this.bio,
    this.grade,
    this.hobbies,
  });
}

class PARUserGet extends PARUser {}