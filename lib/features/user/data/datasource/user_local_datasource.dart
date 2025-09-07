import 'package:smart_learn/core/database/appdatabase.dart';
import 'package:smart_learn/core/database/tables/user_table.dart';
import 'package:smart_learn/features/user/data/models/user_model.dart';

UserTable _userTable = UserTable.instance;

abstract class LDSUser {
  Future<bool> add(MODUser user);
  Future<bool> update(MODUser user);

  Future<MODUser> get();
}

class LDSUserImpl implements LDSUser {
  final appDatabase = AppDatabase.instance;

  @override
  Future<bool> add(MODUser user) async {
    final db = await appDatabase.db;
    final result = await db.insert(
      _userTable.tableName,
      user.toMap(),
    );
    return result > 0;
  }

  @override
  Future<bool> update(MODUser user) async {
    final db = await appDatabase.db;
    final result = await db.update(
      _userTable.tableName,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
    return result > 0;
  }


  @override
  Future<MODUser> get() async {
    final db = await appDatabase.db;
    final result = await db.query(
      _userTable.tableName,
      where: 'id = ?',
      whereArgs: [1],
    );
    return MODUser.fromMap(result.first);
  }
}