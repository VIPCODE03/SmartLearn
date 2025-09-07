import 'package:smart_learn/core/database/tables/user_table.dart';
import 'package:smart_learn/features/user/domain/entities/user_entity.dart';

UserTable _table = UserTable.instance;

class MODUser extends ENTUser {
  const MODUser({
    required super.id,
    required super.name,
    required super.age,
    super.email,
    super.avatar,
    super.bio,
    required super.grade,
    required super.hobbies,
  });

  Map<String, dynamic> toMap() {
    return {
      _table.columnId: id,
      _table.columnName: name,
      _table.columnAge: age,
      _table.columnEmail: email,
      _table.columnAvatar: avatar,
      _table.columnBio: bio,
      _table.columnGrade: grade,
      _table.columnHobbies: hobbies,
    };
  }

  factory MODUser.fromMap(Map<String, dynamic> map) {
    return MODUser(
      id: map[_table.columnId] as String,
      name: map[_table.columnName] as String,
      age: map[_table.columnAge] as int,
      email: map[_table.columnEmail] as String?,
      avatar: map[_table.columnAvatar] as String?,
      bio: map[_table.columnBio] as String?,
      grade: map[_table.columnGrade] as String,
      hobbies: map[_table.columnHobbies] as String,
    );
  }

  factory MODUser.fromEntity(ENTUser entity) {
    return MODUser(
      id: entity.id,
      name: entity.name,
      age: entity.age,
      email: entity.email,
      avatar: entity.avatar,
      bio: entity.bio,
      grade: entity.grade,
      hobbies: entity.hobbies,
    );
  }
}