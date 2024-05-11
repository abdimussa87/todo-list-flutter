import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list/features/todo/views/views.dart';

class NavRouter {
  static String homeRouteName = '/';
  static String addTodoRouteName = 'add';
  static String editTodoRouteName = 'edit';

  /// The route configuration.
  static GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        name: homeRouteName,
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const TodosPage();
        },
        routes: <RouteBase>[
          GoRoute(
            name: addTodoRouteName,
            path: 'add',
            builder: (BuildContext context, GoRouterState state) {
              return const AddTodoPage();
            },
          ),
          GoRoute(
            name: editTodoRouteName,
            path: 'edit/:id',
            builder: (BuildContext context, GoRouterState state) {
              final todoId = int.parse(state.pathParameters['id'] ?? '1');
              return EditTodoPage(todoId: todoId);
            },
          ),
        ],
      ),
    ],
  );
}
