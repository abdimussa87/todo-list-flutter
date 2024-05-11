import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/app_bloc_observer.dart';
import 'package:todo_list/app_theme.dart';
import 'package:todo_list/features/todo/bloc/todo_bloc.dart';
import 'package:todo_list/features/todo/data_provider/todo_data_provider.dart';
import 'package:todo_list/features/todo/repository/todo_repository.dart';
import 'package:todo_list/router.dart';
import 'package:todo_list/utils/db_utils.dart';

void main() {
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TodoRepository(
        todoDataProvider: TodoDataProvider(dbUtils: DBUtils()),
      ),
      child: BlocProvider(
        create: (context) => TodoBloc()..add(GetTodos()),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Todo List',
          theme: AppTheme.light,
          routerConfig: NavRouter.router,
        ),
      ),
    );
  }
}
