import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import '../data/database.dart';

class HomeScreen extends StatefulWidget {
  final AppDatabase database;
  const HomeScreen({super.key, required this.database});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameController = TextEditingController();
  late Future<List<User>> _users;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    _users = widget.database.getAllUsers();
  }

  Future<void> _addUser() async {
    if (_nameController.text.isEmpty) return;
    await widget.database.createUser(
      UsersCompanion(name: drift.Value(_nameController.text)),
    );
    _nameController.clear();
    setState(() {
      _loadUsers();
    });
  }

  void _openUserDetails(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserDetailScreen(user: user, database: widget.database),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Loan & Savings App")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "User Name"),
                ),
              ),
              ElevatedButton(
                  onPressed: _addUser, child: const Text("Add User")),
            ]),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<User>>(
                future: _users,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No users found."));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final user = snapshot.data![index];
                      return ListTile(
                        title: Text(user.name),
                        onTap: () => _openUserDetails(user),
                      );
                    },
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class UserDetailScreen extends StatefulWidget {
  final AppDatabase database;
  final User user;

  const UserDetailScreen(
      {super.key, required this.database, required this.user});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final loanCtrl = TextEditingController();
  final savingCtrl = TextEditingController();

  Future<void> _addLoan() async {
    final amount = double.tryParse(loanCtrl.text);
    if (amount != null) {
      await widget.database.createLoan(LoansCompanion(
        userId: drift.Value(widget.user.id),
        amount: drift.Value(amount),
        startDate: drift.Value(DateTime.now()),
        dueDate: drift.Value(DateTime.now().add(const Duration(days: 30))),
        status: const drift.Value("ongoing"),
      ));
      loanCtrl.clear();
    }
  }

  Future<void> _addSaving() async {
    final amount = double.tryParse(savingCtrl.text);
    if (amount != null) {
      await widget.database.createSaving(SavingsCompanion(
        userId: drift.Value(widget.user.id),
        amount: drift.Value(amount),
        date: drift.Value(DateTime.now()),
      ));
      savingCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.user.name)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(children: [
              Expanded(
                child: TextField(
                  controller: loanCtrl,
                  decoration: const InputDecoration(labelText: "Loan Amount"),
                ),
              ),
              ElevatedButton(
                  onPressed: _addLoan, child: const Text("Add Loan")),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: savingCtrl,
                  decoration: const InputDecoration(labelText: "Saving Amount"),
                ),
              ),
              ElevatedButton(
                  onPressed: _addSaving, child: const Text("Add Saving")),
            ]),
            const SizedBox(height: 20),
            const Text("Reopen screen to refresh data."),
          ],
        ),
      ),
    );
  }
}
