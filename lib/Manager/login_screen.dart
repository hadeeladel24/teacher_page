import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
//import 'signup_screen.dart';
//import 'forgot_password_screen.dart';
import 'manager_home_page.dart';
//import 'teacher_home_page.dart';
//import 'student_home_page.dart';

class Login extends StatefulWidget {
  final String userType; // 'manager', 'teacher', 'student'

  const Login({super.key, required this.userType});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> signin() async {
    try {
      // تحقق من الإيميل في حال كان مدير
      if (widget.userType == 'manager') {
        if (email.text.trim() != 'noor@gmail.com') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('This email is not Manager')),
          );
          return;
        }
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Successfully')),
      );

      // التوجيه حسب نوع المستخدم
      if (widget.userType == 'manager') {
        Get.to(() => ManagerHomePage());
      }/* else if (widget.userType == 'teacher') {
        Get.to(() => TeacherHomePage());
      } else if (widget.userType == 'student') {
        Get.to(() => StudentHomePage());
      }*/

    }
      catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String userTitle;
    if (widget.userType == 'manager') {
      userTitle = 'مدير';
    } else if (widget.userType == 'teacher') {
      userTitle = 'معلم';
    } else {
      userTitle = 'طالب';
    }

    return Scaffold(
      appBar: AppBar(title: Text("تسجيل الدخول كـ $userTitle")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(hintText: 'أدخل البريد الإلكتروني'),
            ),
            TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(hintText: 'أدخل كلمة المرور'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: signin,
              child: Text("تسجيل الدخول"),
            ),
            SizedBox(height: 20),
           /* ElevatedButton(
              onPressed: () => Get.to(() => Signup()),
              child: Text("تسجيل حساب جديد"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.to(() => Forgot()),
              child: Text("هل نسيت كلمة المرور؟"),

            ),
            */
          ],
        ),
      ),
    );
  }
}
