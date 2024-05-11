// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'todo_bloc.dart';

enum ETodoStatus { initial, loading, loaded, error }

enum ETodoEditStatus { initial, loading, loaded, success, error }

enum ETodoDeleteStatus { initial, loading, success, error }

class TodoState extends Equatable {
  final ETodoStatus status;
  final ETodoEditStatus editStatus;
  final ETodoDeleteStatus deleteStatus;
  final Failure failure;
  final String content;
  final List<Todo> todos;
  final Todo todo;

  const TodoState({
    required this.status,
    required this.editStatus,
    required this.deleteStatus,
    required this.failure,
    required this.content,
    required this.todos,
    required this.todo,
  });

  factory TodoState.initial() {
    return const TodoState(
      status: ETodoStatus.initial,
      editStatus: ETodoEditStatus.initial,
      deleteStatus: ETodoDeleteStatus.initial,
      failure: Failure(),
      content: '',
      todos: [],
      todo: Todo.empty,
    );
  }

  @override
  List<Object> get props =>
      [status, editStatus, deleteStatus, failure, content, todos, todo];

  TodoState copyWith({
    ETodoStatus? status,
    ETodoEditStatus? editStatus,
    ETodoDeleteStatus? deleteStatus,
    Failure? failure,
    String? content,
    List<Todo>? todos,
    Todo? todo,
  }) {
    return TodoState(
      status: status ?? this.status,
      editStatus: editStatus ?? this.editStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      failure: failure ?? this.failure,
      content: content ?? this.content,
      todos: todos ?? this.todos,
      todo: todo ?? this.todo,
    );
  }
}
