import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/features/todo/data_provider/todo_data_provider.dart';

class DBUtils {
  Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initialize();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = 'todo.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: createTables,
      singleInstance: true,
    );
    return database;
  }

  Future<void> createTables(Database database, int version) async {
    await TodoDataProvider(dbUtils: DBUtils()).createTable(database);
  }
}
