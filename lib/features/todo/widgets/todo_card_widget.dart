import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list/constants.dart';
import 'package:todo_list/features/todo/bloc/todo_bloc.dart';
import 'package:todo_list/features/todo/models/todo_model.dart';
import 'package:todo_list/router.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  const TodoCard({
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: CheckboxListTile(
        secondary: OutlinedButton(
          onPressed: () {
            context.pushNamed(NavRouter.editTodoRouteName,
                pathParameters: {'id': todo.id.toString()});
          },
          child: const Text('Edit'),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        checkboxShape: const CircleBorder(),
        activeColor: Colors.green,
        title: Text(
          todo.content,
          style: TextStyle(
            color: todo.isCompleted ? Colors.grey : kDarkPurple,
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        value: todo.isCompleted,
        onChanged: (value) {
          context.read<TodoBloc>().add(SetTodoIsCompleted(todo));
        },
      ),
    );
  }
}
