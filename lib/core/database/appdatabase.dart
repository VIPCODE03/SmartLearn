import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:smart_learn/core/database/tables/aihomework_table.dart';
import 'package:smart_learn/core/database/tables/dataanalysis_table.dart';
import 'package:smart_learn/core/database/tables/user_table.dart';
import 'package:smart_learn/core/database/tables/assistant_table.dart';
import 'package:smart_learn/core/database/tables/calendar_table.dart';
import 'package:smart_learn/core/database/tables/file_table.dart';
import 'package:smart_learn/core/database/tables/flashcard_table.dart';
import 'package:smart_learn/core/database/tables/quiz_table.dart';
import 'package:smart_learn/core/database/tables/subject_table.dart';
import 'package:smart_learn/core/database/tables/table.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  static Database? _database;

  List<Table> get tables => [
    AssistantConversationTable.instance,
    AssistantMessageTable.instance,
    CalendarTable.instance,
    FileTable.instance,
    FlashcardSetTable.instance,
    FlashCardTable.instance,
    QuizTable.instance,
    SubjectTable.instance,
    AIHomeWorkTable.instance,
    UserTable.instance,
    DataAnalysisTable.instance,
  ];

  Future<Database> get db async {
    if (_database != null) return _database!;
    return await _initOnce();
  }

  Future<Database> _initOnce() async {
    return await Future.sync(() async {
      if (_database != null) return _database!;
      final path = join(await getDatabasesPath(), 'vlva.db');
      _database = await openDatabase(
        path,
        version: 4,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: (db, version) async {
          for (var table in tables) {
            await db.execute(table.build);
          }
        },
      );
      return _database!;
    });
  }
}
