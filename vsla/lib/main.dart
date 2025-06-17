import 'package:flutter/material.dart';
import 'package:vsla/UI/homescreen.dart';
import 'data/database.dart';

final AppDatabase database = AppDatabase();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loan & Savings',
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(database: database),
    );
  }
}
