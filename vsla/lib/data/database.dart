import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Users, Loans, Repayments, Savings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<User>> getAllUsers() => select(users).get();
  Future<int> createUser(UsersCompanion entry) => into(users).insert(entry);

  Future<int> createLoan(LoansCompanion entry) => into(loans).insert(entry);
  Future<List<Loan>> getLoansByUser(int userId) =>
      (select(loans)..where((tbl) => tbl.userId.equals(userId))).get();

  Future<int> createSaving(SavingsCompanion entry) =>
      into(savings).insert(entry);
  Future<List<Saving>> getSavingsByUser(int userId) =>
      (select(savings)..where((tbl) => tbl.userId.equals(userId))).get();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dir.path, 'app.db'));
    return NativeDatabase(dbFile);
  });
}
