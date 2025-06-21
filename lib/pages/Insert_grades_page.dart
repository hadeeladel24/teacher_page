import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class InsertGradesPage extends StatefulWidget {
  const InsertGradesPage({super.key});

  @override
  State<InsertGradesPage> createState() => _InsertGradesPageState();
}

class _InsertGradesPageState extends State<InsertGradesPage> {
  final database = FirebaseDatabase.instance.ref();
  String? selectedClass;
  String? selectedSubject = 'Arabic';
  List<Map<String, dynamic>> students = [];
  Map<String, TextEditingController> gradeControllers = {};

  List<String> classOptions = ['class-1', 'class-2', 'class-3'];

  @override
  void dispose() {
    for (var controller in gradeControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void fetchStudentsForClass(String classId) async {
    final snapshot = await database.child('Students').get();
    if (snapshot.exists) {
      final data = snapshot.value;
      List<Map<String, dynamic>> studentsList = [];

      if (data is Map) {
        data.forEach((key, value) {
          if (value['class_id'] == classId) {
            studentsList.add({
              'id': key,
              'name': "${value['first_name']} ${value['last_name']}",
            });
          }
        });
      } else if (data is List) {
        for (int i = 0; i < data.length; i++) {
          final student = data[i];
          if (student != null && student['class_id'] == classId) {
            studentsList.add({
              'id': i.toString(),
              'name': "${student['first_name']} ${student['last_name']}",
            });
          }
        }
      }

      setState(() {
        students = studentsList;
        gradeControllers.clear();
        for (var student in students) {
          gradeControllers[student['id']] = TextEditingController();
        }
      });
    }
  }


  void saveGrades() async {
    if (selectedClass == null || selectedSubject == null) return;

    final path = 'grades/$selectedClass/$selectedSubject';

    for (var student in students) {
      final studentId = student['id'];
      final gradeText = gradeControllers[studentId]?.text ?? "";
      if (gradeText.isEmpty) continue;

      final grade = double.tryParse(gradeText);
      if (grade != null) {
        await database.child('$path/$studentId').set({
          'grade': grade,
        });
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Grades saved successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Insert Grades", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedClass,
              hint: const Text("Select Class"),
              items: classOptions.map((classId) {
                return DropdownMenuItem(
                  value: classId,
                  child: Text(classId),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedClass = value);
                fetchStudentsForClass(value!);
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: students.isEmpty
                  ? const Center(child: Text("No students"))
                  : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Student Id')),
                    DataColumn(label: Text('Student Name')),
                    DataColumn(label: Text('Grade')),
                  ],
                  rows: students.map((student) {
                    final controller = gradeControllers[student['id']]!;
                    return DataRow(cells: [
                      DataCell(Text(student['id'])),
                      DataCell(Text(student['name'])),
                      DataCell(
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: "Grade",
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                            ),
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: saveGrades,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white),
              child: const Text("Save Grades"),
            ),
          ],
        ),
      ),
    );
  }
}
