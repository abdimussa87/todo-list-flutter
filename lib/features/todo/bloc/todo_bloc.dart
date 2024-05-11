import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/features/todo/models/failure_model.dart';
import 'package:todo_list/features/todo/models/todo_model.dart';
import 'package:todo_list/features/todo/repository/todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository _todoRepository;
  TodoBloc({TodoRepository? todoRepository})
      : _todoRepository = todoRepository ?? TodoRepository(),
        super(TodoState.initial()) {
    on<GetTodos>(_onGetTodos);
    on<GetTodo>(_onGetTodo);
    on<SetTodoContent>(_onSetTodoContent);
    on<SetTodoIsCompleted>(_onSetTodoIsCompleted);
    on<AddTodoSubmitted>(_onAddTodoSubmitted);
    on<UpdateTodoSubmitted>(_onUpdateTodoSubmitted);
  }

  Future<void> _onGetTodos(GetTodos event, Emitter<TodoState> emit) async {
    try {
      emit(state.copyWith(status: ETodoStatus.loading));
      final todos = await _todoRepository.getTodos();
      emit(state.copyWith(status: ETodoStatus.loaded, todos: todos));
    } catch (err) {
      emit(state.copyWith(
          status: ETodoStatus.error,
          failure: Failure(message: err.toString())));
    }
  }

  Future<void> _onGetTodo(GetTodo event, Emitter<TodoState> emit) async {
    try {
      emit(state.copyWith(editStatus: ETodoEditStatus.loading));
      final todo = await _todoRepository.getTodo(event.id);
      emit(state.copyWith(editStatus: ETodoEditStatus.loaded, todo: todo));
    } catch (err) {
      emit(
        state.copyWith(
          editStatus: ETodoEditStatus.error,
          failure: Failure(message: err.toString()),
        ),
      );
    }
  }

  Future<void> _onSetTodoContent(
      SetTodoContent event, Emitter<TodoState> emit) async {
    emit(state.copyWith(content: event.content));
  }

  Future<void> _onSetTodoIsCompleted(
      SetTodoIsCompleted event, Emitter<TodoState> emit) async {
    try {
      await _todoRepository.updateTodo(event.todo.copyWith(
        isCompleted: !event.todo.isCompleted,
      ));

      final todos = List<Todo>.from(state.todos).map((todo) {
        if (todo.id == event.todo.id) {
          return event.todo.copyWith(isCompleted: !event.todo.isCompleted);
        }
        return todo;
      }).toList();

      emit(state.copyWith(status: ETodoStatus.loaded, todos: todos));
    } catch (err) {
      emit(
        state.copyWith(
            status: ETodoStatus.error,
            failure: Failure(message: err.toString())),
      );
    }
  }

  Future<void> _onAddTodoSubmitted(
      AddTodoSubmitted event, Emitter<TodoState> emit) async {
    try {
      emit(state.copyWith(status: ETodoStatus.loading));
      await _todoRepository.addTodo(Todo(content: state.content));
      final todos = await _todoRepository.getTodos();
      emit(state.copyWith(
          status: ETodoStatus.loaded, todos: todos, content: ''));
    } catch (err) {
      emit(
        state.copyWith(
            status: ETodoStatus.error,
            failure: Failure(message: err.toString())),
      );
    }
  }

  Future<void> _onUpdateTodoSubmitted(
      UpdateTodoSubmitted event, Emitter<TodoState> emit) async {
    try {
      emit(state.copyWith(editStatus: ETodoEditStatus.loading));
      final content =
          state.content.isEmpty ? state.todo.content : state.content;
      await _todoRepository.updateTodo(state.todo.copyWith(content: content));
      final todos = await _todoRepository.getTodos();
      emit(state.copyWith(
          editStatus: ETodoEditStatus.success, todos: todos, content: ''));
    } catch (err) {
      emit(
        state.copyWith(
            editStatus: ETodoEditStatus.error,
            failure: Failure(message: err.toString())),
      );
    }
  }
}
