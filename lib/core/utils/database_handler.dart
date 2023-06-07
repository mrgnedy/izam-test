import 'dart:io';

import 'package:daftra/features/auth/data/repo.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
part 'repo.g.dart';

@DriftDatabase(tables: [Users])
class AppDatabase extends _$MyDatabase {
  AppDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File('${dbFolder.path}/db.sqlite');
    return NativeDatabase.createInBackground(file);
  });
}

