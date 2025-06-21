import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
class addStudent extends StatefulWidget {
  const addStudent({super.key});

  @override
  State<addStudent> createState() => _AddStudent();
}

class _AddStudent extends State<addStudent> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseReference _databaseref = FirebaseDatabase.instance.ref().child('Students');
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _enrollmentDateController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  String? choosegender;
  String? chooseclassid;
  final List<String> classIds = ['class-1', 'class-2', 'class-3', 'class-4', 'class-5','class-6','class-7','class-8',
    'class-9','class-10','class-11'
  ];

  Future<int> _getStudentId() async {
    final snapshot = await _databaseref.get();
    if (!snapshot.exists) {
      return 0;
    }

    final keys = snapshot.children
        .map((child) => int.tryParse(child.key ?? '') ?? 0)
        .where((key) => key != 0)
        .toList();

    if (keys.isEmpty) return 0;

    keys.sort();
    return keys.last;
  }

  void _addStudent() async {
    if (_formKey.currentState!.validate()) {
      try {
        int lastId = await _getStudentId();
        int newId = lastId + 1;

        await _databaseref.child(newId.toString()).set({
          'student_id': newId,
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'BOD': _birthdateController.text,
          'enrollment_date': _enrollmentDateController.text,
          'gender': choosegender ,
          'phone_number': _phoneNumberController.text,
          'status': _statusController.text,
          'class_id': chooseclassid ,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Add student Successful')),
        );

        _formKey.currentState!.reset();
        setState(() {
          choosegender = null;
          chooseclassid = null;
          _firstNameController.clear();
          _lastNameController.clear();
          _birthdateController.clear();
          _enrollmentDateController.clear();
          _phoneNumberController.clear();
          _statusController.clear();
        });

      }
      //if an error happen when you add(ممكن نستغني عنها)
      catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add student')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Student')),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                      labelText: 'First Name', border: OutlineInputBorder()),
                  validator: (value) {
                    if(value==null||value.isEmpty){
                       return'Enter First Name';
                  }
                    else{
                      return null;
                    }
                }
                ),
                 SizedBox(height: 20),
                TextFormField(
                  controller: _lastNameController,
                  decoration:  InputDecoration(
                      labelText: 'Last Name', border: OutlineInputBorder()),
                    validator: (value) {
                      if(value==null||value.isEmpty){
                        return'Enter Last Name';
                      }
                      else{
                        return null;
                      }
                    }
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _birthdateController,
                  decoration:  InputDecoration(
                      labelText: 'Birth Date', border: OutlineInputBorder()),
                    validator: (value) {
                      if(value==null||value.isEmpty){
                        return'Enter Birth Date ';
                      }
                      else{
                        return null;
                      }
                    }
                    ),
                   SizedBox(height: 20),

                   TextFormField(
                  controller: _enrollmentDateController,
                  decoration:  InputDecoration(
                      labelText: 'Enrollment Date',
                      border: OutlineInputBorder()),
                       validator: (value) {
                         if(value==null||value.isEmpty){
                           return'Enter Enrollment Date';
                         }
                         else{
                           return null;
                         }
                       }
                ),
                 SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  value: choosegender,
                  decoration:  InputDecoration(
                      labelText: 'Gender', border: OutlineInputBorder()),
                  items:  [
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      choosegender = value;
                    });
                  },
                    validator: (value) {
                      if(value==null||value.isEmpty){
                        return'Choose Class ID';
                      }
                      else{
                        return null;
                      }
                    }
                ),
                 SizedBox(height: 20),

                TextFormField(
                  controller: _phoneNumberController,
                  decoration:  InputDecoration(
                      labelText: 'Phone Number', border: OutlineInputBorder()),
                    validator: (value) {
                      if(value==null||value.isEmpty){
                        return'Enter Phone Number';
                      }
                      else{
                        return null;
                      }
                    }
                ),
                 SizedBox(height: 20),

                TextFormField(
                  controller: _statusController,
                  decoration:  InputDecoration(
                      labelText: 'State', border: OutlineInputBorder()),
                    validator: (value) {
                      if(value==null||value.isEmpty){
                        return'Enter State';
                      }
                      else{
                        return null;
                      }
                    }
                ),
                 SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  value: chooseclassid,
                  decoration:  InputDecoration(
                      labelText: 'Class ID', border: OutlineInputBorder()),
                  items: classIds
                      .map((cls) =>
                      DropdownMenuItem(value: cls, child: Text(cls)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      chooseclassid = value;
                    });
                  },
                    validator: (value) {
                      if(value==null||value.isEmpty){
                        return'Choose Class ID';
                      }
                      else{
                        return null;
                      }
                    }
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _addStudent,
                  child: const Text('Add Student'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
