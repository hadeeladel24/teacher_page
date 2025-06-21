import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DeleteStudent extends StatefulWidget {
  const DeleteStudent({Key? key}) : super(key: key);

  @override
  State<DeleteStudent> createState() => _DeleteStudentPageState();
}

class _DeleteStudentPageState extends State<DeleteStudent> {
  final _studentIdController = TextEditingController();
  final _databaseRef = FirebaseDatabase.instance.ref().child('Students');

  Future<void> _deleteStudent() async {
    final studentIdText = _studentIdController.text.trim();
    if (studentIdText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter Student Id')),
      );
      return;
    }

    try {
      final studentRef = _databaseRef.child(studentIdText);

      final snapshot = await studentRef.get();
      if (!snapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student not Found')),
        );
      } else {
        await studentRef.remove();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student Deleted Successfully')),
        );
        _studentIdController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Student Information'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            
            TextField(
              controller: _studentIdController,
              decoration: const InputDecoration(
                labelText: 'Enter Student id',
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
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRbc1KHxjYq5sraANm31Fe6JIpdmGFkR25zkA&s',
                    width: 300,
                    height: 300,
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: _deleteStudent,
                    child: const Text('Delete Student'),
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
