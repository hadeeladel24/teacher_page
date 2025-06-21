import 'package:flutter/material.dart';
import 'add_class.dart';
import 'add_student.dart';
import 'add_subject.dart';
import 'add_teacher.dart';
import 'Edit_student.dart';
import 'Edit_teacher.dart';
import 'Delete_student.dart';
import 'delete_teacher.dart';
class ManagerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<_HomeItem> items = [
     /* _HomeItem("Add Classes", Icons.class_, Colors.blueAccent[100]!, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => AddClass()));
      }),
      */
      _HomeItem("Add Student", Icons.person, Colors.blueAccent[100]!, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => addStudent()));
      }),
      _HomeItem("Add Teacher", Icons.person, Colors.blueAccent[100]!, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => AddTeacher()));
      }),
      _HomeItem("Add Subject", Icons.book, Colors.blueAccent[100]!, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => AddSubject()));
      }),
      _HomeItem("Add Class", Icons.book, Colors.blueAccent[100]!, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) =>AddClass() ));
      }),

      _HomeItem("Delete Student", Icons.delete, Colors.blueAccent[100]!, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) =>DeleteStudent() ));
      }),
     _HomeItem("Delete Teacher", Icons.delete, Colors.blueAccent[100]!, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => DeleteTeacher()));
      }),

      _HomeItem("Edit Teacher", Icons.mode_edit_outline, Colors.blueAccent[100]!, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) =>EditTeacher()));
      }),
      _HomeItem("Edit Student", Icons.mode_edit_outline, Colors.blueAccent[100]!, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => EditStudent()));
      }),
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Hello Noor",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),) ,
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
