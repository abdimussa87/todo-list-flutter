import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list/constants.dart';
import 'package:todo_list/features/todo/bloc/todo_bloc.dart';
import 'package:todo_list/utils/snackbar_utils.dart';

class EditTodoPage extends StatefulWidget {
  final int todoId;
  const EditTodoPage({super.key, required this.todoId});

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // getting the todo
    context.read<TodoBloc>().add(GetTodo(widget.todoId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
        (TodoBloc bloc) => bloc.state.editStatus == ETodoEditStatus.loading);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      body: BlocConsumer<TodoBloc, TodoState>(
        listenWhen: (previous, current) =>
            previous.editStatus != current.editStatus,
        listener: (context, state) {
          if (state.editStatus == ETodoEditStatus.error) {
            showSnackbar(
              context,
              SnackbarType.error,
              state.failure.message,
            );
          }

          if (state.editStatus == ETodoEditStatus.success) {
            showSnackbar(
              context,
              SnackbarType.success,
              'Todo Edited Successfully',
            );
            context.pop();
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 40, 10, 15),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Task Name',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 15),
                  if (state.editStatus == ETodoEditStatus.loaded)
                    Container(
                      constraints: const BoxConstraints(minHeight: 70),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey, width: 2),
                      ),
                      child: TextFormField(
                        initialValue: state.todo.content,
                        maxLines: 2,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          context.read<TodoBloc>().add(
                                SetTodoContent(value),
                              );
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please add task name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Get groceries...',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                          contentPadding: const EdgeInsets.only(
                            top: 10,
                            left: 15,
                            right: 10,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  const Spacer(),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _submitForm(isLoading);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: kDarkPurple, width: 2),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 1,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text('Done'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _submitForm(bool isLoading) {
    if (_formKey.currentState!.validate()) {
      if (isLoading) {
        return;
      }
      context.read<TodoBloc>().add(UpdateTodoSubmitted());
    }
  }
}
