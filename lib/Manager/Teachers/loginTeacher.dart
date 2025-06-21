import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'TeacherHomePage.dart';
import 'signUpTeacher.dart';
import 'forgetPassTeacher.dart';


class LoginT extends StatefulWidget {
  const LoginT({super.key});

  @override
  State<LoginT> createState() => _LoginState();
}

class _LoginState extends State<LoginT> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> signin() async {
    try {
      final userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );


      final snapshot = await FirebaseDatabase.instance.ref('teachers').get();

      if (snapshot.exists) {
        final data = snapshot.value;
        String? teacherId;

        if (data is Map) {
          data.forEach((key, value) {
            if (value['email'] == email.text.trim()) {
              teacherId = key; // key هو الـ teacherId (مثل "1" أو "2")
            }
          });
        } else if (data is List) {
          for (int i = 0; i < data.length; i++) {
            final value = data[i];
            if (value != null && value['email'] == email.text.trim()) {
              teacherId = i.toString();
              break;
            }
          }
        }

        if (teacherId != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => TeacherHomePage(teacherId: teacherId!),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No teacher found with this email')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No teachers data found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: signin,
              child: Text("Login"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (_) => Signup()));},
              child: Text("Register now"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (_) => Forgot()))},
              child: Text("Forgot password?"),
            ),
          ],
        ),
      ),
    );
  }
}