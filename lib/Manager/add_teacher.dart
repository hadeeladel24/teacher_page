import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddTeacher extends StatefulWidget {
  const AddTeacher({super.key});

  @override
  State<AddTeacher> createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseReference _dataref = FirebaseDatabase.instance.ref().child('teachers');

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _createdAtController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _gender;

  Future<int> _getTeacherId() async {
    final snapshot = await _dataref.get();
    if (!snapshot.exists) return 0;

    final keys = snapshot.children
        .map((child) => int.tryParse(child.key ?? '') ?? 0)
        .where((id) => id != 0)
        .toList();

    if (keys.isEmpty) return 0;

    keys.sort();
    return keys.last;
  }

  void _addTeacher() async {
    if (_formKey.currentState!.validate()) {
      try {
        final lastId = await _getTeacherId();
        final newId = lastId + 1;
        await _dataref.child(newId.toString()).set({
          'teacher_id': newId,
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'birth_date': _birthDateController.text,
          'created_at': _createdAtController.text,
          'email': _emailController.text,
          'phone_number': _phoneNumberController.text,
          'salary': _salaryController.text,
          'specialization': _specializationController.text,
          'address': _addressController.text,
          'gender': _gender ,
        });

        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Teacher added successfully')),
        );
        _formKey.currentState!.reset();
        setState(() {
          _gender = null;
          _firstNameController.clear();
          _lastNameController.clear();
          _addressController.clear();
          _birthDateController.clear();
          _createdAtController.clear();
          _emailController.clear();
          _phoneNumberController.clear();
          _salaryController.clear();
          _specializationController.clear();

        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Failed to add teacher')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text('Add Teacher')),
      body: Padding(
        padding:  EdgeInsets.all(14.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration:  InputDecoration(labelText: 'First Name', border: OutlineInputBorder()),
                    validator: (value) {
                      if(value==null||value.isEmpty){
                        return'Enter First Name';
                      }
                      else{
                        return null;
                      }
                    }
                ),
                 SizedBox(height: 16),
                TextFormField(
                  controller: _lastNameController,
                  decoration:  InputDecoration(labelText: 'Last Name', border: OutlineInputBorder()),
                  validator: (value) {
                    if(value==null||value.isEmpty){
                      return'Enter Last Name';
                    }
                    else{
                      return null;
                    }
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _birthDateController,
                  decoration:  InputDecoration(labelText: 'Birth Date', border: OutlineInputBorder()),
                    validator: (value) {
                      if(value==null||value.isEmpty){
                        return'Enter Birth Date';
                      }
                      else{
                        return null;
                      }
                    }
                ),
                 SizedBox(height: 16),
                TextFormField(
                  controller: _createdAtController,
                  decoration:  InputDecoration(labelText: 'Created At', border: OutlineInputBorder()),
                    validator: (value) {
                      if(value==null||value.isEmpty){
                        return'Enter Created at Date';
                      }
                      else{
                        return null;
                      }
                    }
                ),
                 SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration:  InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                    validator: (value) {
                      if(value==null||value.isEmpty){
                        return'Enter Email';
                      }
                      else{
                        return null;
                      }
                    }
                ),
                 SizedBox(height: 16),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration:  InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                    validator: (value) {
                      if(value==null||value.isEmpty){
                        return'Enter phone number';
                      }
                      else{
                        return null;
                      }
                    }
                ),
                 SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: InputDecoration(labelText: 'Gender', border: OutlineInputBorder()),
                  items:  [
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                    validator: (value) {
                      if(value==null||value.isEmpty){
                        return'Select Gender';
                      }
                      else{
                        return null;
                      }
                    }
                ),
                 SizedBox(height: 16),
                TextFormField(
                  controller: _salaryController,
                  decoration:  InputDecoration(labelText: 'Salary', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                    validator: (value) {
                      if(value==null||value.isEmpty){
                        return'Enter Salary';
                      }
                      else{
                        return null;
                      }
                    }
                ),
                 SizedBox(height: 16),
                TextFormField(
                  controller: _specializationController,
                  decoration:  InputDecoration(labelText: 'Specialization', border: OutlineInputBorder()),
                    validator: (value) {
                      if(value==null||value.isEmpty){
                        return'Enter Specialization';
                      }
                      else{
                        return null;
                      }
                    }
                ),
                 SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration:  InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
                    validator: (value) {
                      if(value==null||value.isEmpty){
                        return'Enter Address';
                      }
                      else{
                        return null;
                      }
                    }
                ),
                 SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addTeacher,
                  child:  Text('Add Teacher'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
