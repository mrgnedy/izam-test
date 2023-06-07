import 'package:daftra/features/auth/data/repo.dart';
import 'package:daftra/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/utils/database_handler.dart';
import 'features/auth/data/user_handler.dart';
import 'features/auth/presentation/ui/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final authCubit = AuthCubit(LocalDBRepo(UserHandler(AppDatabase())));
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider.value(
        value: authCubit,
        child: const LoginScreen(),
      ),
    );
  }
}
