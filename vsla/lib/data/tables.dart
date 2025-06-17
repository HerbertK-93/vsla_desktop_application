import 'package:drift/drift.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

class Loans extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  RealColumn get amount => real()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get dueDate => dateTime()();
  TextColumn get status => text()();
}

class Repayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get loanId => integer()();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
}

class Savings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
}
