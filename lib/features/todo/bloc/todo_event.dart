part of 'todo_bloc.dart';

sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class GetTodos extends TodoEvent {}

class GetTodo extends TodoEvent {
  final int id;

  const GetTodo(this.id);
  @override
  List<Object> get props => [id];
}

class SetTodoContent extends TodoEvent {
  final String content;

  const SetTodoContent(this.content);

  @override
  List<Object> get props => [content];
}

class SetTodoIsCompleted extends TodoEvent {
  final Todo todo;

  const SetTodoIsCompleted(this.todo);

  @override
  List<Object> get props => [todo];
}

class AddTodoSubmitted extends TodoEvent {}

class UpdateTodoSubmitted extends TodoEvent {}

class DeleteTodo extends TodoEvent {
  final Todo todo;

  const DeleteTodo(this.todo);

  @override
  List<Object> get props => [todo];
}
