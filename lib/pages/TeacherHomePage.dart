import 'package:flutter/material.dart';
import 'classes_page.dart';
import 'attendance_page.dart';
import 'contact_us_page.dart';
import 'Grade_Veiw.dart';
class TeacherHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<_HomeItem> items = [
      _HomeItem("Classes", Icons.class_, Colors.blueAccent[100]!, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => StudentsOfTeacherClassPage()));
      }),


      _HomeItem("Attendance", Icons.event_available, Colors.blueAccent[100]!, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => AttendancePage()));
      }),


      _HomeItem("Contact Us", Icons.contact_mail, Colors.blueAccent[100]!, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ContactUsPage()));
      }),


      _HomeItem(" Grades", Icons.grade_sharp, Colors.blueAccent[100]!, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
      })
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Hello Teacher",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),) ,
      backgroundColor: Colors.blueAccent,

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