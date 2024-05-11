// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final int? id;
  final String content;
  final bool isCompleted;

  const Todo({
    this.id,
    required this.content,
    this.isCompleted = false,
  });

  static const empty = Todo(id: 0, content: '', isCompleted: false);

  factory Todo.fromDB(Map<String, Object?> map) {
    return Todo(
      id: map['id'] as int,
      content: map['content'] as String,
      isCompleted: map['isCompleted'] == 1 ? true : false,
    );
  }

  @override
  List<Object?> get props => [id, content, isCompleted];

  Todo copyWith({
    int? id,
    String? content,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      content: content ?? this.content,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
