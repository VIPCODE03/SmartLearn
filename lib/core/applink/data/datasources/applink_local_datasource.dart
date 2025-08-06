import 'package:smart_learn/core/applink/data/models/applink_model.dart';
import 'package:smart_learn/core/database/appdatabase.dart';
import 'package:sqflite/sqflite.dart';

abstract class LDSAppLink {
  Future<bool> createLink(MODAppLink link);
  Future<bool> deleteLink(MODAppLink link);
  Future<bool> updateLink(MODAppLink link);
  Future<MODAppLink?> getLink(MODAppLink link);
}

class LDSAppLinkImpl extends LDSAppLink {
  final _database = AppDatabase.instance;

  @override
  Future<bool> createLink(MODAppLink link) async {
    final db = await _database.db;
    try {
      await db.insert(
        link.table.tableName,
        link.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> deleteLink(MODAppLink link) async {
    final db = await _database.db;
    final count = await db.delete(
      link.table.tableName,
      where: '${link.table.columnLinkId} = ?',
      whereArgs: [link.id],
    );
    return count > 0;
  }

  @override
  Future<bool> updateLink(MODAppLink link) async {
    final db = await _database.db;
    final count = await db.update(
      link.table.tableName,
      link.toJson(),
      where: '${link.table.columnLinkId} = ?',
      whereArgs: [link.id],
    );
    return count > 0;
  }

  @override
  Future<MODAppLink?> getLink(MODAppLink linkId) async {
    // final db = await _database.db;
    // final result = await db.query(
    //   tableName,
    //   where: 'id = ?',
    //   whereArgs: [linkId],
    //   limit: 1,
    // );
    // if (result.isNotEmpty) {
    //   return MODAppLink.fromJson(result.first);
    // }
    return null;
  }
}
