import 'package:sqflite/sqflite.dart';
import 'package:todo_list/features/todo/models/todo_model.dart';
import 'package:todo_list/utils/db_utils.dart';

class TodoDataProvider {
  final DBUtils _dbUtils;
  TodoDataProvider({DBUtils? dbUtils}) : _dbUtils = dbUtils ?? DBUtils();

  final tableName = 'todos';

  // Creates a todos table in the given database if it does not exist.
  Future<void> createTable(Database database) async {
    await database.execute(
      '''CREATE TABLE IF NOT EXISTS $tableName(
      "id" INTEGER NOT NULL,
      "content" TEXT NOT NULL,
      "isCompleted" INTEGER NOT NULL DEFAULT 0,
      PRIMARY KEY ("id" AUTOINCREMENT)
      ); ''',
    );
  }

  /// Inserts a new todo item into the database with the given content.
  ///
  /// Parameters:
  ///   - `content`: The content of the todo item to be inserted. (required)
  ///
  /// Returns:
  ///   - A `Future` that completes when the insertion is done.
  Future<void> addTodo(Todo todo) async {
    final database = await _dbUtils.database;
    await database.rawInsert(
        '''INSERT INTO $tableName (content) VALUES (?)''', [todo.content]);
  }

  // Retrieves a list of Todo objects by querying the database and mapping
  // the results to Todo objects.
  // Returns a Future that completes with a list of Todo objects.
  Future<List<Todo>> getTodos() async {
    final database = await _dbUtils.database;
    final todos = await database.rawQuery('SELECT * FROM $tableName');
    return todos.map((todo) => Todo.fromDB(todo)).toList();
  }

  // Retrieves a single Todo object from the database based on the provided id.
  Future<Todo> getTodo(int id) async {
    final database = await _dbUtils.database;
    final todo =
        await database.rawQuery('SELECT * FROM $tableName WHERE id = ?', [id]);
    return Todo.fromDB(todo.first);
  }

  // Updates a todo item in the database with the provided Todo object.
  // Parameters:
  //   - `todo`: The Todo object containing updated information. (required)
  // Returns:
  //   - A `Future` that completes when the todo item is successfully updated.
  Future<void> updateTodo(Todo todo) async {
    final database = await _dbUtils.database;
    await database.rawUpdate(
        '''UPDATE $tableName SET content = ?, isCompleted = ? WHERE id = ?''',
        [todo.content, todo.isCompleted ? 1 : 0, todo.id]);
  }

  /// Deletes a todo item from the database with the given todo object.
  ///
  /// Parameters:
  ///   - `todo`: The todo object to be deleted. (required)
  ///
  /// Returns:
  ///   - A `Future` that completes when the todo item is successfully deleted.
  Future<void> deleteTodo(Todo todo) async {
    final database = await _dbUtils.database;
    await database.rawDelete('DELETE FROM $tableName WHERE id = ?', [todo.id]);
  }
}
