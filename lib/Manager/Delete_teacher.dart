import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DeleteTeacher extends StatefulWidget {
  const DeleteTeacher({Key? key}) : super(key: key);

  @override
  State<DeleteTeacher> createState() => _DeleteTeacherPageState();
}

class _DeleteTeacherPageState extends State<DeleteTeacher> {
  final _teacherIdController = TextEditingController();
  final _databaseRef = FirebaseDatabase.instance.ref().child('teachers'); // مسار المعلمين

  Future<void> _deleteTeacher() async {
    final teacherIdText = _teacherIdController.text.trim();
    if (teacherIdText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter Teacher Id')),
      );
      return;
    }

    try {
      final teacherRef = _databaseRef.child(teacherIdText);

      final snapshot = await teacherRef.get();
      if (!snapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Teacher not Found')),
        );
      } else {
        await teacherRef.remove();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Teacher Deleted Successfully')),
        );
        _teacherIdController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    _teacherIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Teacher Information'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // حقل إدخال رقم المعلم
            TextField(
              controller: _teacherIdController,
              decoration: const InputDecoration(
                labelText: 'Enter Teacher id',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTK2W3noOx1p78322OqOGghLVbGhLE2nmChUg&s',
                    width: 300,
                    height: 300,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _deleteTeacher,
                    child: const Text('Delete Teacher'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
