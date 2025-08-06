// lib/core/database/database_helper.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await init();
    return _database!;
  }

  Future<Database> init() async {
    final path = join(await getDatabasesPath(), 'flashcard.db');
    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE flashcard_sets (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE flashcards (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            set_id INTEGER,
            question TEXT,
            answer TEXT,
            FOREIGN KEY(set_id) REFERENCES flashcard_sets(id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }
}

// lib/features/flashcard_set/domain/entities/flashcard_set.dart
class FlashcardSet {
  final int? id;
  final String name;

  FlashcardSet({this.id, required this.name});

  FlashcardSet copyWith({int? id, String? name}) {
    return FlashcardSet(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}

// lib/features/flashcard/domain/entities/flashcard.dart
class Flashcard {
  final int? id;
  final int setId;
  final String question;
  final String answer;

  Flashcard({this.id, required this.setId, required this.question, required this.answer});

  Flashcard copyWith({int? id, int? setId, String? question, String? answer}) {
    return Flashcard(
      id: id ?? this.id,
      setId: setId ?? this.setId,
      question: question ?? this.question,
      answer: answer ?? this.answer,
    );
  }
}

// lib/features/flashcard_set/domain/repositories/flashcard_set_repository.dart
abstract class FlashcardSetRepository {
  Future<List<FlashcardSet>> getAllSets();
  Future<FlashcardSet> createSet(FlashcardSet set);
  Future<void> updateSet(FlashcardSet set);
  Future<void> deleteSet(int id);
}

// lib/features/flashcard/domain/repositories/flashcard_repository.dart
abstract class FlashcardRepository {
  Future<List<Flashcard>> getFlashcardsBySetId(int setId);
  Future<Flashcard> createFlashcard(Flashcard flashcard);
  Future<void> updateFlashcard(Flashcard flashcard);
  Future<void> deleteFlashcard(int id);
}

// lib/features/flashcard_set/domain/use_cases/get_all_sets_use_case.dart
class GetAllSetsUseCase {
  final FlashcardSetRepository _repository;

  GetAllSetsUseCase(this._repository);

  Future<List<FlashcardSet>> call() {
    return _repository.getAllSets();
  }
}

// lib/features/flashcard_set/domain/use_cases/create_set_use_case.dart
class CreateSetUseCase {
  final FlashcardSetRepository _repository;

  CreateSetUseCase(this._repository);

  Future<FlashcardSet> call(FlashcardSet set) {
    return _repository.createSet(set);
  }
}

// lib/features/flashcard_set/domain/use_cases/update_set_use_case.dart
class UpdateSetUseCase {
  final FlashcardSetRepository _repository;

  UpdateSetUseCase(this._repository);

  Future<void> call(FlashcardSet set) {
    return _repository.updateSet(set);
  }
}

// lib/features/flashcard_set/domain/use_cases/delete_set_use_case.dart
class DeleteSetUseCase {
  final FlashcardSetRepository _repository;

  DeleteSetUseCase(this._repository);

  Future<void> call(int id) {
    return _repository.deleteSet(id);
  }
}

// lib/features/flashcard/domain/use_cases/get_flashcards_by_set_id_use_case.dart
class GetFlashcardsBySetIdUseCase {
  final FlashcardRepository _repository;

  GetFlashcardsBySetIdUseCase(this._repository);

  Future<List<Flashcard>> call(int setId) {
    return _repository.getFlashcardsBySetId(setId);
  }
}

// lib/features/flashcard/domain/use_cases/create_flashcard_use_case.dart
class CreateFlashcardUseCase {
  final FlashcardRepository _repository;

  CreateFlashcardUseCase(this._repository);

  Future<Flashcard> call(Flashcard flashcard) {
    return _repository.createFlashcard(flashcard);
  }
}

// lib/features/flashcard/domain/use_cases/update_flashcard_use_case.dart
class UpdateFlashcardUseCase {
  final FlashcardRepository _repository;

  UpdateFlashcardUseCase(this._repository);

  Future<void> call(Flashcard flashcard) {
    return _repository.updateFlashcard(flashcard);
  }
}

// lib/features/flashcard/domain/use_cases/delete_flashcard_use_case.dart
class DeleteFlashcardUseCase {
  final FlashcardRepository _repository;

  DeleteFlashcardUseCase(this._repository);

  Future<void> call(int id) {
    return _repository.deleteFlashcard(id);
  }
}

// lib/features/flashcard_set/data/models/flashcard_set_model.dart
class FlashcardSetModel {
  final int? id;
  final String name;

  FlashcardSetModel({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory FlashcardSetModel.fromMap(Map<String, dynamic> map) {
    return FlashcardSetModel(
      id: map['id'],
      name: map['name'],
    );
  }

  FlashcardSet toEntity() {
    return FlashcardSet(id: id, name: name);
  }

  factory FlashcardSetModel.fromEntity(FlashcardSet entity) {
    return FlashcardSetModel(id: entity.id, name: entity.name);
  }
}

// lib/features/flashcard/data/models/flashcard_model.dart
class FlashcardModel {
  final int? id;
  final int setId;
  final String question;
  final String answer;

  FlashcardModel({this.id, required this.setId, required this.question, required this.answer});

  Map<String, dynamic> toMap() {
    return {'id': id, 'set_id': setId, 'question': question, 'answer': answer};
  }

  factory FlashcardModel.fromMap(Map<String, dynamic> map) {
    return FlashcardModel(
      id: map['id'],
      setId: map['set_id'],
      question: map['question'],
      answer: map['answer'],
    );
  }

  Flashcard toEntity() {
    return Flashcard(id: id, setId: setId, question: question, answer: answer);
  }

  factory FlashcardModel.fromEntity(Flashcard entity) {
    return FlashcardModel(id: entity.id, setId: entity.setId, question: entity.question, answer: entity.answer);
  }
}

class FlashcardSetRepositoryImpl implements FlashcardSetRepository {
  final DatabaseHelper _dbHelper;

  FlashcardSetRepositoryImpl(this._dbHelper);

  @override
  Future<List<FlashcardSet>> getAllSets() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('flashcard_sets');
    return maps.map((map) => FlashcardSetModel.fromMap(map).toEntity()).toList();
  }

  @override
  Future<FlashcardSet> createSet(FlashcardSet set) async {
    final db = await _dbHelper.database;
    final id = await db.insert('flashcard_sets', FlashcardSetModel.fromEntity(set).toMap());
    return set.copyWith(id: id);
  }

  @override
  Future<void> updateSet(FlashcardSet set) async {
    final db = await _dbHelper.database;
    await db.update('flashcard_sets', FlashcardSetModel.fromEntity(set).toMap(), where: 'id = ?', whereArgs: [set.id]);
  }

  @override
  Future<void> deleteSet(int id) async {
    final db = await _dbHelper.database;
    await db.delete('flashcard_sets', where: 'id = ?', whereArgs: [id]);
  }
}

class FlashcardRepositoryImpl implements FlashcardRepository {
  final DatabaseHelper _dbHelper;

  FlashcardRepositoryImpl(this._dbHelper);

  @override
  Future<List<Flashcard>> getFlashcardsBySetId(int setId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('flashcards');
    return maps.map((map) => FlashcardModel.fromMap(map).toEntity()).toList();
  }

  @override
  Future<Flashcard> createFlashcard(Flashcard flashcard) async {
    final db = await _dbHelper.database;
    final id = await db.insert('flashcards', FlashcardModel.fromEntity(flashcard).toMap());
    return flashcard.copyWith(id: id);
  }

  @override
  Future<void> updateFlashcard(Flashcard flashcard) async {
    final db = await _dbHelper.database;
    await db.update('flashcards', FlashcardModel.fromEntity(flashcard).toMap(), where: 'id = ?', whereArgs: [flashcard.id]);
  }

  @override
  Future<void> deleteFlashcard(int id) async {
    final db = await _dbHelper.database;
    await db.delete('flashcards', where: 'id = ?', whereArgs: [id]);
  }
}

class FlashcardSetProvider with ChangeNotifier {
  final GetAllSetsUseCase _getAllSetsUseCase;
  final CreateSetUseCase _createSetUseCase;
  final UpdateSetUseCase _updateSetUseCase;
  final DeleteSetUseCase _deleteSetUseCase;

  List<FlashcardSet> _sets = [];

  FlashcardSetProvider({
    required GetAllSetsUseCase getAllSetsUseCase,
    required CreateSetUseCase createSetUseCase,
    required UpdateSetUseCase updateSetUseCase,
    required DeleteSetUseCase deleteSetUseCase,
  })  : _getAllSetsUseCase = getAllSetsUseCase,
        _createSetUseCase = createSetUseCase,
        _updateSetUseCase = updateSetUseCase,
        _deleteSetUseCase = deleteSetUseCase;

  Future<void> loadSets() async {
    _sets = await _getAllSetsUseCase();
    notifyListeners();
  }

  Future<void> addSet(String name) async {
    final newSet = FlashcardSet(name: name);
    final createdSet = await _createSetUseCase(newSet);
    _sets.add(createdSet);
    notifyListeners();
  }

  Future<void> updateSet(FlashcardSet set) async {
    await _updateSetUseCase(set);
    final index = _sets.indexWhere((s) => s.id == set.id);
    if (index != -1) {
      _sets[index] = set;
      notifyListeners();
    }
  }

  Future<void> deleteSet(int id) async {
    await _deleteSetUseCase(id);
    _sets.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  List<FlashcardSet> get sets => _sets;
}

class FlashcardProvider with ChangeNotifier {
  final GetFlashcardsBySetIdUseCase _getFlashcardsBySetIdUseCase;
  final CreateFlashcardUseCase _createFlashcardUseCase;
  final UpdateFlashcardUseCase _updateFlashcardUseCase;
  final DeleteFlashcardUseCase _deleteFlashcardUseCase;

  List<Flashcard> _flashcards = [];
  int? _currentSetId;

  FlashcardProvider({
    required GetFlashcardsBySetIdUseCase getFlashcardsBySetIdUseCase,
    required CreateFlashcardUseCase createFlashcardUseCase,
    required UpdateFlashcardUseCase updateFlashcardUseCase,
    required DeleteFlashcardUseCase deleteFlashcardUseCase,
  })  : _getFlashcardsBySetIdUseCase = getFlashcardsBySetIdUseCase,
        _createFlashcardUseCase = createFlashcardUseCase,
        _updateFlashcardUseCase = updateFlashcardUseCase,
        _deleteFlashcardUseCase = deleteFlashcardUseCase;

  Future<void> loadFlashcards(int setId) async {
    _currentSetId = setId;
    _flashcards = await _getFlashcardsBySetIdUseCase(setId);
    notifyListeners();
  }

  Future<void> addFlashcard(int setId, String question, String answer) async {
    final newFlashcard = Flashcard(setId: setId, question: question, answer: answer);
    final createdFlashcard = await _createFlashcardUseCase(newFlashcard);
    if (setId == _currentSetId) {
      _flashcards.add(createdFlashcard);
      notifyListeners();
    }
  }

  Future<void> updateFlashcard(Flashcard flashcard) async {
    await _updateFlashcardUseCase(flashcard);
    final index = _flashcards.indexWhere((f) => f.id == flashcard.id);
    if (index != -1) {
      _flashcards[index] = flashcard;
      notifyListeners();
    }
  }

  Future<void> deleteFlashcard(int id) async {
    await _deleteFlashcardUseCase(id);
    _flashcards.removeWhere((f) => f.id == id);
    notifyListeners();
  }

  List<Flashcard> get flashcards => _flashcards;
}

class FlashcardSetListScreen extends StatelessWidget {
  const FlashcardSetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FlashcardSetProvider>(context, listen: false);
    provider.loadSets();

    return Scaffold(
      appBar: AppBar(title: Text('Quản lý Flashcard Sets')),
      body: Consumer<FlashcardSetProvider>(
        builder: (context, provider, child) {
          if (provider.sets.isEmpty) {
            return Center(child: Text('Không có set nào'));
          }
          return ListView.builder(
            itemCount: provider.sets.length,
            itemBuilder: (context, index) {
              final set = provider.sets[index];
              return ListTile(
                title: Text(set.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.visibility),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FlashcardListScreen(setId: set.id!),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => provider.deleteSet(set.id!),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final name = await _showAddSetDialog(context);
          if (name != null) provider.addSet(name);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<String?> _showAddSetDialog(BuildContext context) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thêm Set mới'),
        content: TextField(controller: controller, decoration: InputDecoration(hintText: 'Tên set')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text('Thêm'),
          ),
        ],
      ),
    );
  }
}

class FlashcardListScreen extends StatelessWidget {
  final int setId;

  FlashcardListScreen({required this.setId});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FlashcardProvider>(context, listen: false);
    provider.loadFlashcards(setId);

    return Scaffold(
      appBar: AppBar(title: Text('Quản lý Flashcards')),
      body: Consumer<FlashcardProvider>(
        builder: (context, provider, child) {
          if (provider.flashcards.isEmpty) {
            return Center(child: Text('Không có flashcard nào'));
          }
          return ListView.builder(
            itemCount: provider.flashcards.length,
            itemBuilder: (context, index) {
              final flashcard = provider.flashcards[index];
              return ListTile(
                title: Text(flashcard.question),
                subtitle: Text(flashcard.answer),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => provider.deleteFlashcard(flashcard.id!),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await _showAddFlashcardDialog(context);
          if (result != null) provider.addFlashcard(setId, result['question']!, result['answer']!);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<Map<String, String>?> _showAddFlashcardDialog(BuildContext context) {
    final questionController = TextEditingController();
    final answerController = TextEditingController();
    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thêm Flashcard mới'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: questionController, decoration: InputDecoration(hintText: 'Câu hỏi')),
            TextField(controller: answerController, decoration: InputDecoration(hintText: 'Đáp án')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, {
              'question': questionController.text,
              'answer': answerController.text,
            }),
            child: Text('Thêm'),
          ),
        ],
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final databaseHelper = DatabaseHelper();
  await databaseHelper.init();

  final flashcardSetRepository = FlashcardSetRepositoryImpl(databaseHelper);
  final flashcardRepository = FlashcardRepositoryImpl(databaseHelper);

  runApp(
    MultiProvider(
      providers: [
        Provider<FlashcardSetRepository>.value(value: flashcardSetRepository),
        Provider<FlashcardRepository>.value(value: flashcardRepository),
        Provider<GetAllSetsUseCase>(create: (_) => GetAllSetsUseCase(flashcardSetRepository)),
        Provider<CreateSetUseCase>(create: (_) => CreateSetUseCase(flashcardSetRepository)),
        Provider<UpdateSetUseCase>(create: (_) => UpdateSetUseCase(flashcardSetRepository)),
        Provider<DeleteSetUseCase>(create: (_) => DeleteSetUseCase(flashcardSetRepository)),
        Provider<GetFlashcardsBySetIdUseCase>(create: (_) => GetFlashcardsBySetIdUseCase(flashcardRepository)),
        Provider<CreateFlashcardUseCase>(create: (_) => CreateFlashcardUseCase(flashcardRepository)),
        Provider<UpdateFlashcardUseCase>(create: (_) => UpdateFlashcardUseCase(flashcardRepository)),
        Provider<DeleteFlashcardUseCase>(create: (_) => DeleteFlashcardUseCase(flashcardRepository)),
        ChangeNotifierProvider(
          create: (_) => FlashcardSetProvider(
            getAllSetsUseCase: GetAllSetsUseCase(flashcardSetRepository),
            createSetUseCase: CreateSetUseCase(flashcardSetRepository),
            updateSetUseCase: UpdateSetUseCase(flashcardSetRepository),
            deleteSetUseCase: DeleteSetUseCase(flashcardSetRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => FlashcardProvider(
            getFlashcardsBySetIdUseCase: GetFlashcardsBySetIdUseCase(flashcardRepository),
            createFlashcardUseCase: CreateFlashcardUseCase(flashcardRepository),
            updateFlashcardUseCase: UpdateFlashcardUseCase(flashcardRepository),
            deleteFlashcardUseCase: DeleteFlashcardUseCase(flashcardRepository),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng Flashcard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FlashcardSetListScreen(),
    );
  }
}