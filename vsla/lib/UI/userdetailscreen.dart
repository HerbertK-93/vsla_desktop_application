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
  final List<List<TextEditingController>> _welfareRows = [];
  final List<List<TextEditingController>> _penaltyRows = [];

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
      _savingsRows.add(List.generate(3, (_) => TextEditingController()));
    });
  }

  void _addLoansRow() {
    setState(() {
      _loansRows.add(List.generate(6, (_) => TextEditingController()));
    });
  }

  void _addWelfareRow() {
    setState(() {
      _welfareRows.add(List.generate(3, (_) => TextEditingController()));
    });
  }

  void _addPenaltyRow() {
    setState(() {
      _penaltyRows.add(List.generate(3, (_) => TextEditingController()));
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

  void _clearLastWelfareRow() {
    if (_welfareRows.isNotEmpty) {
      setState(() {
        _welfareRows.removeLast();
      });
    }
  }

  void _clearLastPenaltyRow() {
    if (_penaltyRows.isNotEmpty) {
      setState(() {
        _penaltyRows.removeLast();
      });
    }
  }

  void _printSavingsLedger() {
    print("Printing Savings Ledger for user: ${widget.user.name}");
  }

  void _printLoansLedger() {
    print("Printing Loans Ledger for user: ${widget.user.name}");
  }

  void _printWelfareLedger() {
    print("Printing Welfare Ledger for user: ${widget.user.name}");
  }

  void _printPenaltiesLedger() {
    print("Printing Penalties Ledger for user: ${widget.user.name}");
  }

  void _saveSavings() {
    print("Saving Savings data...");
  }

  void _saveLoans() {
    print("Saving Loans data...");
  }

  void _saveWelfare() {
    print("Saving Welfare data...");
  }

  void _savePenalties() {
    print("Saving Penalties data...");
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
          columnWidths: {
            for (int i = 0; i < headers.length; i++)
              i: const FlexColumnWidth(2),
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

  Widget _buildSection({
    required String title,
    required List<String> headers,
    required List<List<TextEditingController>> rows,
    required VoidCallback onAdd,
    required VoidCallback onClear,
    required VoidCallback onSave,
    VoidCallback? onPrint,
  }) {
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
            Expanded(child: Text(title)),
            if (onPrint != null)
              IconButton(
                icon: const Icon(Icons.print),
                onPressed: onPrint,
                tooltip: "Print $title Ledger",
              ),
          ],
        ),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildStyledTable(
            headers: headers,
            rows: rows,
            onAdd: onAdd,
            onClear: onClear,
          ),
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton(
              onPressed: onSave,
              child: const Text("Save"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsSection() {
    return _buildSection(
      title: "➕ Add Savings",
      headers: ["DATE", "SAVING NO", "AMOUNT"],
      rows: _savingsRows,
      onAdd: _addSavingsRow,
      onClear: _clearLastSavingsRow,
      onSave: _saveSavings,
      onPrint: _printSavingsLedger,
    );
  }

  Widget _buildLoansSection() {
    return _buildSection(
      title: "➕ Add Loans",
      headers: [
        "DATE",
        "LOAN NO",
        "AMOUNT",
        "INTEREST",
        "BALANCE",
        "LOAN PAYMENT"
      ],
      rows: _loansRows,
      onAdd: _addLoansRow,
      onClear: _clearLastLoansRow,
      onSave: _saveLoans,
      onPrint: _printLoansLedger,
    );
  }

  Widget _buildWelfareSection() {
    return _buildSection(
      title: "➕ Welfare",
      headers: ["DATE", "WELFARE NO", "AMOUNT"],
      rows: _welfareRows,
      onAdd: _addWelfareRow,
      onClear: _clearLastWelfareRow,
      onSave: _saveWelfare,
      onPrint: _printWelfareLedger,
    );
  }

  Widget _buildPenaltiesSection() {
    return _buildSection(
      title: "➕ Penalties",
      headers: ["DATE", "PENALTY NO", "AMOUNT"],
      rows: _penaltyRows,
      onAdd: _addPenaltyRow,
      onClear: _clearLastPenaltyRow,
      onSave: _savePenalties,
      onPrint: _printPenaltiesLedger,
    );
  }

  Widget _buildClientInformation() {
    final user = widget.user;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
          ),
        ),
        const SizedBox(width: 20),
        Container(
          width: 400,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: const Center(
            child: Text(
              "ID Image",
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ),
      ],
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
            const SizedBox(height: 20),
            Text("Manage Account",
                style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 20),
            _buildSavingsSection(),
            _buildLoansSection(),
            _buildWelfareSection(),
            _buildPenaltiesSection(),
          ],
        ),
      ),
    );
  }
}
