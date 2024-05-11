import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list/constants.dart';
import 'package:todo_list/features/todo/bloc/todo_bloc.dart';
import 'package:todo_list/features/todo/widgets/todo_card_widget.dart';
import 'package:todo_list/router.dart';
import 'package:todo_list/utils/snackbar_utils.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(NavRouter.addTodoRouteName);
        },
        backgroundColor: kDarkBlue,
        child: const Icon(
          Icons.add,
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TodoBloc, TodoState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == ETodoStatus.error) {
                showSnackbar(
                  context,
                  SnackbarType.error,
                  state.failure.message,
                );
              }
            },
          ),
          BlocListener<TodoBloc, TodoState>(
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
            },
          ),
        ],
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state.status == ETodoStatus.initial ||
                state.status == ETodoStatus.loading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (state.status == ETodoStatus.error) {
              return ElevatedButton(
                onPressed: () {
                  context.read<TodoBloc>().add(GetTodos());
                },
                child: const Text('Retry'),
              );
            }
            return Column(
              children: [
                _buildProfileContainer(),
                _buildSubscriptionContainer(),
                if (state.todos.isEmpty)
                  const Expanded(child: Center(child: Text('No todos yet.'))),
                if (state.todos.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.todos.length,
                      itemBuilder: (context, index) {
                        final todo = state.todos[index];
                        return TodoCard(todo: todo);
                      },
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }

  Container _buildSubscriptionContainer() {
    return Container(
      color: kGreen,
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              child: ListTile(
                leading: Image.asset(
                  'assets/icons/trophy-icon.png',
                ),
                title: const Text(
                  'Go Pro (No Ads)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'No fuss, no ads, for only \$1 a month',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: kPurple,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: kDarkerPurpler,
            height: 70,
            width: 60,
            alignment: Alignment.center,
            child: Text(
              '\$1',
              style: TextStyle(
                  color: kGold, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Container _buildProfileContainer() {
    return Container(
      color: kDarkBlue,
      height: 130,
      padding: const EdgeInsets.fromLTRB(15, 30, 25, 20),
      child: const ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Hello, Abdulhamid',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          'abdimussa87@gmail.com',
          style: TextStyle(
              fontWeight: FontWeight.w300, color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
