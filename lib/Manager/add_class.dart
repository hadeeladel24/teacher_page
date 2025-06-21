import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddClass extends StatefulWidget {
  const AddClass({super.key});

  @override
  State<AddClass> createState() => _AddClassScreenState();
}

class _AddClassScreenState extends State<AddClass> {
  final _formKey = GlobalKey<FormState>();
  final _classNameController = TextEditingController();
  final _teacherIdController = TextEditingController();
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref().child('Classes');

  void _addClass() async {
    if (_formKey.currentState!.validate()) {
      final className = _classNameController.text.trim();
      final teacherId = int.tryParse(_teacherIdController.text.trim());

      if (teacherId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invaled teacher id')),
        );
        return;
      }

      try {
        await _databaseRef.child(className).set({
          'class_name': className,
          'teacher_id': teacherId,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('class added successfully')),
        );

        _formKey.currentState!.reset();
        _classNameController.clear();
        _teacherIdController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erorr: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // خلفية ناعمة
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text('➕ إضافة صف جديد'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          elevation: 12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '📝 معلومات الصف',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _classNameController,
                    decoration: InputDecoration(
                      labelText: 'اسم الصف',
                      prefixIcon: const Icon(Icons.class_),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? '⚠️ أدخل اسم الصف' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _teacherIdController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'معرّف المعلم',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? '⚠️ أدخل معرف المعلم' : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _addClass,
                      icon: const Icon(Icons.save),
                      label: const Text('حفظ الصف'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}