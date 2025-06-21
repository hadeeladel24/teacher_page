import 'package:flutter/material.dart';
import 'classes_page.dart';
import 'attendance_page.dart';
import 'contact_us_page.dart';
import 'Home_Grade_Veiw.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
class TeacherHomePage extends StatelessWidget {
  final String teacherId;

  const TeacherHomePage({super.key, required this.teacherId});
  @override
  Widget build(BuildContext context) {
    List<_HomeItem> items = [
      _HomeItem("My Students", Icons.class_, Colors.blueAccent[100]!, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => StudentsOfTeacherClassPage(teacherId: teacherId)));
      }),


      _HomeItem("Attendance", Icons.event_available, Colors.blueAccent[100]!, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => AttendancePage(teacherId: teacherId)));
      }),


      _HomeItem("Contact Us", Icons.contact_mail, Colors.blueAccent[100]!, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ContactUsPage()));
      }),


      _HomeItem(" Grades", Icons.grade_sharp, Colors.blueAccent[100]!, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage(teacherId: teacherId)));
      })
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: FutureBuilder<String?>(
          future: fetchTeacherFullName(teacherId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading...", style: TextStyle(color: Colors.white));
            } else if (snapshot.hasData) {
              return Text("Hello, ${snapshot.data!}", style: const TextStyle(fontSize: 22, color: Colors.white));
            } else {
              return const Text("Hello Teacher", style: TextStyle(fontSize: 22, color: Colors.white));
            }
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
    itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) => _buildGridItem(items[index]),
        ),
      ),
    );
  }

  Widget _buildGridItem(_HomeItem item) {
    return InkWell(
      onTap: item.onTap,
      child: Card(
        color: item.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, size: 50, color: Colors.white),
              SizedBox(height: 10),
              Text(item.title, style: TextStyle(fontSize: 18, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _HomeItem(this.title, this.icon, this.color, this.onTap);
}

Future<String?> fetchTeacherFullName(String teacherId) async {
  final dbRef = FirebaseDatabase.instance.ref();
  final snapshot = await dbRef.child('teachers/$teacherId').get();

  if (snapshot.exists) {
    final data = snapshot.value as Map<dynamic, dynamic>;
    final firstName = data['first_name'];
    final lastName = data['last_name'];
    return '$firstName $lastName';
  }else{
  return null;
  }
}