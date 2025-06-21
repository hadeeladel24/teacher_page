import 'package:flutter/material.dart';
import 'Teachers/loginTeacher.dart';
import 'login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("اختر الدور")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginT()),
                );
              },
              icon: const Icon(Icons.school),
              label: const Text("تسجيل دخول المعلم"),
            ),
            const SizedBox(height: 20),

            // زر المدير
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login(userType: 'manager',)),
                );
              },
              icon: const Icon(Icons.admin_panel_settings),
              label: const Text("تسجيل دخول المدير"),
            ),
          ],
        ),
      ),
    );
  }
}
