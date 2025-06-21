import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EditStudent extends StatefulWidget {
  const EditStudent({super.key});

  @override
  State<EditStudent> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudent> {
  final _formKey = GlobalKey<FormState>();
  final _database = FirebaseDatabase.instance.ref();

  final _studentIdController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _genderController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _classIdController = TextEditingController();
  final _statusController = TextEditingController();
  final _enrollmentDateController = TextEditingController();

  bool _studentInfoLoaded = false;

  Future<void> _loadStudentData() async {
    final id = _studentIdController.text;
    if (id.isEmpty) return;

    final snapshot = await _database.child('Students/$id').get();
    if (snapshot.exists) {
      final data = snapshot.value as Map;

      setState(() {
        _firstNameController.text = data['first_name'] ?? '';
        _lastNameController.text = data['last_name'] ?? '';
        _phoneController.text = data['phone_number'] ?? '';
        _genderController.text = data['gender'] ?? '';
        _birthDateController.text = data['BOD'] ?? '';
        _classIdController.text = data['class_id'] ?? '';
        _statusController.text = data['status'] ?? '';
        _enrollmentDateController.text = data['enrollment_date'] ?? '';
        _studentInfoLoaded = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student not found')),
      );
      setState(() {
        _studentInfoLoaded = false;
      });
    }
  }

  Future<void> _updateStudentData() async {
    final id = _studentIdController.text;
    if (_formKey.currentState!.validate()) {
      await _database.child('Students/$id').update({
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'phone_number': _phoneController.text,
        'gender': _genderController.text,
        'BOD': _birthDateController.text,
        'class_id': _classIdController.text,
        'status': _statusController.text,
        'enrollment_date': _enrollmentDateController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student information updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Student Information')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _studentIdController,
              decoration: InputDecoration(
                labelText: 'Student ID',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadStudentData,
              child: const Text('Load Student Information'),
            ),
            const SizedBox(height: 16),
            if (_studentInfoLoaded)
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                          prefixIcon: const Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter First Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                          prefixIcon: const Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Last Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                          prefixIcon: const Icon(Icons.phone),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Phone Number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _genderController,
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                          prefixIcon: const Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Gender';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _birthDateController,
                        decoration: InputDecoration(
                          labelText: 'Birth Date',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                          prefixIcon: const Icon(Icons.calendar_today),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Birth Date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _classIdController,
                        decoration: InputDecoration(
                          labelText: 'Class ID',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                          prefixIcon: const Icon(Icons.class_),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Class ID';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _statusController,
                        decoration: InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                          prefixIcon: const Icon(Icons.info),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Status';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _enrollmentDateController,
                        decoration: InputDecoration(
                          labelText: 'Enrollment Date',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                          prefixIcon: const Icon(Icons.date_range),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Enrollment Date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _updateStudentData,
                        child: const Text('Update'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
