import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'TeacherHomePage.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final database = FirebaseDatabase.instance.ref();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> signup() async {
    try {
      final snapshot = await database.child('teachers').get();

      String? existingTeacherId;

      if (snapshot.exists) {
        final data = snapshot.value;

        if (data is Map) {
          data.forEach((key, value) {
            if (value['email']?.toString().toLowerCase() == email.text.trim().toLowerCase()) {
              existingTeacherId = key;
            }
          });
        } else if (data is List) {
          for (int i = 0; i < data.length; i++) {
            final value = data[i];
            if (value != null && value['email']?.toString().toLowerCase() == email.text.trim().toLowerCase()) {
              existingTeacherId = i.toString();
              break;
            }
          }
        }
      }

      if (existingTeacherId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('this email dose not exist please contact with manager')),
        );
        return;
      }

      final methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email.text.trim());

      if (methods.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('this email already registered')),
        );
        return;
      }

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      Get.offAll(() => TeacherHomePage(teacherId: existingTeacherId!));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(hintText: 'Enter email'),
            ),
            TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(hintText: 'Enter password'),
            ),
            ElevatedButton(
              onPressed: signup,
              child: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
