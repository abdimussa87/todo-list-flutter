import 'package:todo_list/features/todo/data_provider/todo_data_provider.dart';
import 'package:todo_list/features/todo/models/todo_model.dart';
import 'package:todo_list/utils/db_utils.dart';

class TodoRepository {
  final TodoDataProvider _todoDataProvider;
  TodoRepository({TodoDataProvider? todoDataProvider})
      : _todoDataProvider =
            todoDataProvider ?? TodoDataProvider(dbUtils: DBUtils());

  Future<List<Todo>> getTodos() async {
    return await _todoDataProvider.getTodos();
  }

  Future<Todo> getTodo(int id) async {
    final todo = await _todoDataProvider.getTodo(id);
    return todo;
  }

  Future<void> addTodo(Todo todo) async {
    await _todoDataProvider.addTodo(todo);
  }

  Future<void> updateTodo(Todo todo) async {
    await _todoDataProvider.updateTodo(todo);
  }

  Future<void> deleteTodo(Todo todo) async {
    await _todoDataProvider.deleteTodo(todo);
  }
}
