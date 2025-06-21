import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class StudentsOfTeacherClassPage extends StatefulWidget {
  final String teacherId;
  const StudentsOfTeacherClassPage({required this.teacherId, super.key});

  @override
  State<StudentsOfTeacherClassPage> createState() => _StudentsOfTeacherClassPageState();
}

class _StudentsOfTeacherClassPageState extends State<StudentsOfTeacherClassPage> {
  final database = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> students = [];
  String? classId;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchClassAndStudents();
  }

  void fetchClassAndStudents() async {
    try {
      final classSnapshot = await database.child('Classes').get();
      if (classSnapshot.exists) {
        final classData = classSnapshot.value;
        String? foundClassId;

        if (classData is Map) {
          classData.forEach((key, value) {
            if (value is Map && value['teacher_id'].toString() == widget.teacherId) {
              foundClassId = key;
            }
          });
        } else if (classData is List) {
          for (int i = 0; i < classData.length; i++) {
            final value = classData[i];
            if (value != null && value['teacher_id'].toString() == widget.teacherId) {
              foundClassId = i.toString();
              break;
            }
          }
        }

        if (foundClassId != null) {
          classId = foundClassId;
          final studentsSnapshot = await database.child('Students').get();
          if (studentsSnapshot.exists) {
            final sData = studentsSnapshot.value;
            List<Map<String, dynamic>> tempStudents = [];

            if (sData is Map) {
              sData.forEach((key, value) {
                if (value['class_id'] == classId) {
                  tempStudents.add({
                    'id': key,
                    'name': "${value['first_name']} ${value['last_name']}",
                    'gender': value['gender'] ?? '-',
                    'phone': value['phone_number'] ?? '-',
                  });
                }
              });
            } else if (sData is List) {
              for (int i = 0; i < sData.length; i++) {
                final value = sData[i];
                if (value != null && value['class_id'] == classId) {
                  tempStudents.add({
                    'id': i.toString(),
                    'name': "${value['first_name']} ${value['last_name']}",
                    'gender': value['gender'] ?? '-',
                    'phone': value['phone_number'] ?? '-',
                  });
                }
              }
            }

            setState(() {
              students = tempStudents;
              loading = false;
            });
          }
        } else {
          print("No class found for teacher_id = ${widget.teacherId}");
        }
      }
    } catch (e) {
      print("Error: $e");
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Students of Your Class", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : students.isEmpty
          ? const Center(child: Text("No students found"))
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text("ID")),
            DataColumn(label: Text("Name")),
            DataColumn(label: Text("Gender")),
            DataColumn(label: Text("Phone")),
          ],
          rows: students.map((student) {
            return DataRow(cells: [
              DataCell(Text(student['id'])),
              DataCell(Text(student['name'])),
              DataCell(Text(student['gender'])),
              DataCell(Text(student['phone'])),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
