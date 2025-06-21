import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class AttendancePage extends StatefulWidget {
  final String teacherId;
  const AttendancePage({super.key, required this.teacherId});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String? selectedClass;
  Map<String, bool> attendanceStatus = {};
  List<Map<String, dynamic>> students = [];
  final database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    fetchClassForTeacher(widget.teacherId);
  }

  void fetchClassForTeacher(String teacherId) async {
    final snapshot = await database.child('Classes').get();
    if (snapshot.exists) {
      final data = snapshot.value;
      String? classId;

      if (data is Map) {
        data.forEach((key, value) {
          if (value['teacher_id'].toString() == teacherId) {
            classId = key;
          }
        });
      } else if (data is List) {
        for (int i = 0; i < data.length; i++) {
          final value = data[i];
          if (value != null && value['teacher_id'].toString() == teacherId) {
            classId = i.toString();
            break;
          }
        }
      }

      if (classId != null) {
        setState(() {
          selectedClass = classId;
        });
        fetchStudentsForClass(classId!);
      } else {
        print("No class found for teacher with ID $teacherId");
      }
    }
  }

  void fetchStudentsForClass(String classId) async {
    final snapshot = await database.child('Students').get();
    if (snapshot.exists) {
      final data = snapshot.value;
      List<Map<String, dynamic>> studentsList = [];

      if (data is Map) {
        studentsList = data.entries
            .where((e) => e.value['class_id'] == classId)
            .map((e) => {
          'id': e.key,
          'name': "${e.value['first_name']} ${e.value['last_name']}",
          'phone': e.value['phone_number'] ?? '',
        })
            .toList();
      } else if (data is List) {
        for (int i = 0; i < data.length; i++) {
          final student = data[i];
          if (student != null && student['class_id'] == classId) {
            studentsList.add({
              'id': i.toString(),
              'name': "${student['first_name']} ${student['last_name']}",
              'phone': student['phone_number'] ?? '',
            });
          }
        }
      }

      setState(() {
        students = studentsList;
        for (var student in students) {
          attendanceStatus[student['id']] = false;
        }
      });
    }
  }

  void saveAttendance() {
    if (selectedClass == null || attendanceStatus.isEmpty) return;

    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final path = 'attendance/$selectedClass/$date';

    for (var student in students) {
      final studentId = student['id'];
      final isPresent = attendanceStatus[studentId] ?? false;
      final status = isPresent ? 'present' : 'absent';

      database.child('$path/$studentId').set({'status': status});
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Attendance saved successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Insert Students Attendance",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (selectedClass != null)
              Text("Class: $selectedClass",
                  style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Expanded(
              child: students.isEmpty
                  ? const Center(child: Text("No students"))
                  : ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  final studentId = student['id'].toString();
                  return CheckboxListTile(
                    title: Text(student['name']),
                    value: attendanceStatus[studentId] ?? false,
                    onChanged: (value) {
                      setState(() {
                        attendanceStatus[studentId] = value!;
                      });
                    },
                    secondary: const Icon(Icons.person),
                    controlAffinity: ListTileControlAffinity.leading,
                    subtitle: Text("Phone: ${student['phone']}"),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: saveAttendance,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white),
              child: const Text("Save Attendance"),
            ),
          ],
        ),
      ),
    );
  }
}
