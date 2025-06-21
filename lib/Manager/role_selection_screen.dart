import 'package:flutter/material.dart';
import 'login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  Widget buildRoleCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 40, color: color),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade100, Colors.lightBlue.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: [
            SizedBox(height: 60),
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: Colors.white,
                child: Icon(Icons.school, size: 48, color: Colors.blueAccent),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'أهلاً بك في المدرسة الإلكترونية',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 40),
            buildRoleCard(
              context: context,
              icon: Icons.school,
              title: 'تسجيل الدخول كطالب',
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Login(userType: 'student')),
                );
              },
            ),
            buildRoleCard(
              context: context,
              icon: Icons.person,
              title: 'تسجيل الدخول كمعلم',
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Login(userType: 'teacher')),
                );
              },
            ),
            buildRoleCard(
              context: context,
              icon: Icons.admin_panel_settings,
              title: 'تسجيل الدخول كمدير',
              color: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Login(userType: 'manager')),
                );
              },
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
