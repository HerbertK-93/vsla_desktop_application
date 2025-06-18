import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../data/database.dart';

class UserDetailScreen extends StatefulWidget {
  final AppDatabase database;
  final User user;

  const UserDetailScreen({
    super.key,
    required this.database,
    required this.user,
  });

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final loanCtrl = TextEditingController();
  final savingCtrl = TextEditingController();

  final List<List<TextEditingController>> _savingsRows = [];
  final List<List<TextEditingController>> _loansRows = [];

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

  void _addSavingsRow() {
    setState(() {
      _savingsRows.add(List.generate(4, (_) => TextEditingController()));
    });
  }

  void _addLoansRow() {
    setState(() {
      _loansRows.add(List.generate(4, (_) => TextEditingController()));
    });
  }

  void _clearLastSavingsRow() {
    if (_savingsRows.isNotEmpty) {
      setState(() {
        _savingsRows.removeLast();
      });
    }
  }

  void _clearLastLoansRow() {
    if (_loansRows.isNotEmpty) {
      setState(() {
        _loansRows.removeLast();
      });
    }
  }

  void _printSavingsLedger() {
    print("Printing Savings Ledger for user: ${widget.user.name}");
  }

  void _printLoansLedger() {
    print("Printing Loans Ledger for user: ${widget.user.name}");
  }

  void _saveSavings() {
    print("Saving Savings data...");
  }

  void _saveLoans() {
    print("Saving Loans data...");
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildHeaderRow(List<String> headers) {
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFFE0E0E0)),
      children: headers
          .map((text) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ))
          .toList(),
    );
  }

  TableRow _buildEditableRow(List<TextEditingController> controllers) {
    return TableRow(
      decoration: const BoxDecoration(color: Colors.white),
      children: controllers
          .map((ctrl) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                  controller: ctrl,
                  decoration: const InputDecoration(
                      isDense: true, border: OutlineInputBorder()),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildStyledTable({
    required List<String> headers,
    required List<List<TextEditingController>> rows,
    required VoidCallback onAdd,
    required VoidCallback onClear,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          border: TableBorder.all(color: Colors.black45),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(2),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            _buildHeaderRow(headers),
            ...rows.map(_buildEditableRow),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text("Add Row"),
            ),
            TextButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.clear),
              label: const Text("Clear Row"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSavingsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            const Expanded(child: Text("➕ Add Savings")),
            IconButton(
              icon: const Icon(Icons.print),
              onPressed: _printSavingsLedger,
              tooltip: "Print Savings Ledger",
            ),
          ],
        ),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildStyledTable(
            headers: ["DATE", "SAVING NO", "AMOUNT", "RETURNS"],
            rows: _savingsRows,
            onAdd: _addSavingsRow,
            onClear: _clearLastSavingsRow,
          ),
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton(
              onPressed: _saveSavings,
              child: const Text("Save"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoansSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            const Expanded(child: Text("➕ Add Loans")),
            IconButton(
              icon: const Icon(Icons.print),
              onPressed: _printLoansLedger,
              tooltip: "Print Loans Ledger",
            ),
          ],
        ),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildStyledTable(
            headers: ["DATE", "LOAN NO", "AMOUNT", "BALANCE"],
            rows: _loansRows,
            onAdd: _addLoansRow,
            onClear: _clearLastLoansRow,
          ),
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton(
              onPressed: _saveLoans,
              child: const Text("Save"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientInformation() {
    final user = widget.user;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          _buildInfoRow("Client Name", user.name),
          const Divider(),
          _buildInfoRow("Client ID", "CL-00123"),
          const Divider(),
          _buildInfoRow("ID Number", "1234567890"),
          const Divider(),
          _buildInfoRow("Contact", "+123456789"),
          const Divider(),
          _buildInfoRow("Address", "123 Village Lane"),
          const Divider(),
          _buildInfoRow("Date Opened", "2025-06-18"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Client Information",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            _buildClientInformation(),
            const SizedBox(height: 20), // Reduced padding here
            Text("Manage Account",
                style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildSavingsSection()),
                const SizedBox(width: 20),
                Expanded(child: _buildLoansSection()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
