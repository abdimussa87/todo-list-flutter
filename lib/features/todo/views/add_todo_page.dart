import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list/constants.dart';
import 'package:todo_list/features/todo/bloc/todo_bloc.dart';
import 'package:todo_list/utils/snackbar_utils.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // removing any previous todo content
    context.read<TodoBloc>().add(const SetTodoContent(''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context
        .select((TodoBloc bloc) => bloc.state.status == ETodoStatus.loading);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
      ),
      body: BlocConsumer<TodoBloc, TodoState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == ETodoStatus.error) {
            showSnackbar(
              context,
              SnackbarType.error,
              state.failure.message,
            );
          }

          if (state.status == ETodoStatus.loaded) {
            showSnackbar(
              context,
              SnackbarType.success,
              'Todo Added Successfully',
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
                  Container(
                    constraints: const BoxConstraints(minHeight: 70),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                    child: TextFormField(
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
      context.read<TodoBloc>().add(AddTodoSubmitted());
    }
  }
}
