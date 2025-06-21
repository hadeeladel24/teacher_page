import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SafeGradesListPage extends StatefulWidget {
  final String teacherId;
  const SafeGradesListPage({super.key, required this.teacherId});

  @override
  State<SafeGradesListPage> createState() => _SafeGradesListPageState();
}


class _SafeGradesListPageState extends State<SafeGradesListPage> {
  final database = FirebaseDatabase.instance.ref();

  List<Map<String, dynamic>> grades = [];
  Map<String, Map<String, dynamic>> studentsMap = {};

  String? selectedClass;
  final List<String> classOptions = [];

  @override
  @override
  void initState() {
    super.initState();
    fetchClasses();
    fetchTeacherSubject();
  }
  void fetchClasses() async {
    final snapshot = await database.child('Classes').get();
    if (snapshot.exists) {
      final data = snapshot.value;
      List<String> classes = [];

      if (data is Map) {
        classes = data.keys.map((key) => key.toString()).toList();
      } else if (data is List) {
        for (int i = 0; i < data.length; i++) {
          if (data[i] != null) classes.add(i.toString());
        }
      }

      setState(() {
        classOptions.clear();
        classOptions.addAll(classes);
      });
    }
  }

  String? subject;

  void fetchTeacherSubject() async {
    final snapshot = await database.child('teachers/${widget.teacherId}').get();
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      setState(() {
        subject = data['specialization']?.toString();
      });
    }
  }


  Future<void> loadData(String classId, String subjectId) async {

    final studentsSnapshot = await database.child('Students').get();
    if (studentsSnapshot.exists) {
      final data = studentsSnapshot.value;

      Map<String, Map<String, dynamic>> tempStudentsMap = {};

      if (data is Map) {
        data.forEach((key, value) {
          tempStudentsMap[key.toString()] = {
            'first_name': value['first_name'] ?? '',
            'last_name': value['last_name'] ?? '',
            'class_id': value['class_id'] ?? '',
          };
        });
      } else if (data is List) {
        for (int i = 0; i < data.length; i++) {
          final value = data[i];
          if (value != null) {
            tempStudentsMap[i.toString()] = {
              'first_name': value['first_name'] ?? '',
              'last_name': value['last_name'] ?? '',
              'class_id': value['class_id'] ?? '',
            };
          }
        }
      }


      studentsMap = Map.fromEntries(
        tempStudentsMap.entries.where((e) => e.value['class_id'] == classId),
      );
    }


    final gradesSnapshot = await database.child('grades/$classId/$subjectId').get();

    List<Map<String, dynamic>> gradesList = [];

    if (gradesSnapshot.exists) {
      final data = gradesSnapshot.value;

      if (data is Map) {
        gradesList = data.entries.map((e) {
          final studentId = e.key.toString();
          final grade = e.value['grade'];
          final student = studentsMap[studentId];
          return {
            'studentId': studentId,
            'grade': grade,
            'studentName': student != null
                ? "${student['first_name']} ${student['last_name']}"
                : "Unknown",
          };
        }).toList();
      } else if (data is List) {
        for (int i = 0; i < data.length; i++) {
          final entry = data[i];
          if (entry != null && entry['grade'] != null) {
            final student = studentsMap[i.toString()];
            gradesList.add({
              'studentId': i.toString(),
              'grade': entry['grade'],
              'studentName': student != null
                  ? "${student['first_name']} ${student['last_name']}"
                  : "Unknown",
            });
          }
        }
      }
    }

    setState(() {
      grades = gradesList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grades Page", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Select Class",
                border: OutlineInputBorder(),
              ),
              value: selectedClass,
              items: classOptions
                  .map((c) => DropdownMenuItem(
                value: c,
                child: Text(c),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedClass = value;
                  grades = [];
                });
                if (value != null && subject != null) {
                  loadData(value, subject!);
                }
              },

            ),
            const SizedBox(height: 20),
            Expanded(
              child: grades.isEmpty
                  ? const Center(child: Text("No grades found"))
                  : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Student ID')),
                    DataColumn(label: Text('Student Name')),
                    DataColumn(label: Text('Grade')),
                  ],
                  rows: grades.map((g) {
                    return DataRow(cells: [
                      DataCell(Text(g['studentId'])),
                      DataCell(Text(g['studentName'])),
                      DataCell(Text(g['grade'].toString())),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
