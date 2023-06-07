import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:daftra/core/utils/database_handler.dart';
import 'package:daftra/core/utils/hash_password.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

import 'package:daftra/core/utils/validators.dart';

import 'user_handler.dart';

class LocalDBRepo {
  final UserHandler userTableHandler;

  LocalDBRepo(this.userTableHandler);

  Future<int> login(String email, String password) async {
    final foundUser = await _getUserWith(email);
    if (foundUser != null) {
      final hashedPassword = hashPassword(password);
      final isPasswordCorrect = foundUser.password == hashedPassword;
      if (isPasswordCorrect) {
        final updatedUser = await _updateUser(foundUser);
        if (updatedUser != null) {
          return updatedUser.count;
        } else {
          throw Exception("Error updating user login count");
        }
      } else {
        throw Exception("Incorrect password");
      }
    } else {
      final loginCount = _createUser(email, password);
      return loginCount;
    }
  }

  Future<User?> _getUserWith(String email) async {
    final allUsers = await userTableHandler.queryUser(email);
    return allUsers.firstOrNull;
  }

  int _createUser(String email, String password) {
    final hashedPassword = hashPassword(password);
    final newUser = UsersCompanion.insert(
      email: email,
      password: hashedPassword,
      count: const Value(1),
    );
    userTableHandler.insert(newUser);
    return newUser.count.value;
  }

  Future<User?> _updateUser(User foundUser) async {
    final updatedUser = foundUser.copyWith(count: foundUser.count + 1);
    final updated = await userTableHandler.update(updatedUser);
    if (updated) return updatedUser;
  }
}

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get count => integer().withDefault(const Constant(0))();
  TextColumn get email => text().unique()();
  TextColumn get password => text()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
