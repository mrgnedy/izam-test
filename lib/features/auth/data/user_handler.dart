import 'package:daftra/core/utils/database_handler.dart';
import 'package:drift/drift.dart';

class UserHandler {
  final AppDatabase database;

  UserHandler(this.database);

  Future<List<User>> queryUser(String email) =>
      (database.select(database.users)..where((tbl) => tbl.email.equals(email)))
          .get();
  Future<int> insert(Insertable<User> user) =>
      database.into(database.users).insert(user);
  Future<bool> update(User user) =>
      database.update(database.users).replace(user);
}
