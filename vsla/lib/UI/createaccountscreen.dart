import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:drift/drift.dart' as drift;
import '../data/database.dart';

class CreateAccountScreen extends StatefulWidget {
  final AppDatabase database;
  const CreateAccountScreen({super.key, required this.database});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _nameController = TextEditingController();
  final _clientIdController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  File? _idImageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _idImageFile = File(picked.path);
      });
    }
  }

  Future<void> _createAccount() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    await widget.database.createUser(
      UsersCompanion(name: drift.Value(name)),
    );

    Navigator.pop(context);
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Enter Client Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Removed redundant title

          // Name
          TextField(
            controller: _nameController,
            decoration: _inputDecoration("Client Name"),
          ),
          const SizedBox(height: 20),

          // Client ID
          TextField(
            controller: _clientIdController,
            decoration: _inputDecoration("Client ID"),
          ),
          const SizedBox(height: 20),

          // ID Number
          TextField(
            controller: _idNumberController,
            decoration: _inputDecoration("Client ID Number"),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),

          // Contact
          TextField(
            controller: _contactController,
            decoration: _inputDecoration("Client Contact"),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),

          // Address
          TextField(
            controller: _addressController,
            decoration: _inputDecoration("Client Address"),
          ),
          const SizedBox(height: 20),

          // Date Picker
          InputDecorator(
            decoration: _inputDecoration("Date"),
            child: InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "${_selectedDate.toLocal()}".split(' ')[0],
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Attach ID Image - Styled Container
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Attach Client ID Image",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.upload_file),
                      label: const Text("Upload ID Image"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        side: const BorderSide(color: Colors.blue),
                        textStyle: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 20),
                    if (_idImageFile != null)
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blueGrey, width: 1),
                          image: DecorationImage(
                            image: FileImage(_idImageFile!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          Center(
            child: OutlinedButton(
              onPressed: _createAccount,
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                side: const BorderSide(color: Colors.blue),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text("Save Account"),
            ),
          ),
        ],
      ),
    );
  }
}
