import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EditTeacher extends StatefulWidget {
  const EditTeacher({super.key});

  @override
  State<EditTeacher> createState() => _EditTeacherScreenState();
}

class _EditTeacherScreenState extends State<EditTeacher> {
  final _formKey = GlobalKey<FormState>();
  final _database = FirebaseDatabase.instance.ref();

  final _teacherIdController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _genderController = TextEditingController();
  final _specializationController = TextEditingController();
  final _salaryController = TextEditingController();

  bool _teacherinfo = false;

  Future<void> _loadTeacherData() async {
    final id = _teacherIdController.text;
    if (id.isEmpty)
      return;
    final snapshot = await _database.child('teachers/$id').get();
    if (snapshot.exists) {
      final data = snapshot.value as Map;

      setState(() {
        if (data['first_name'] != null) {
          _firstNameController.text = data['first_name'];
        } else {
          _firstNameController.text = '';
        }
        if (data['Last_name'] != null) {
          _lastNameController.text = data['last_name'];
        } else {
          _lastNameController.text = '';
        }
        if (data['email'] != null) {
          _emailController.text = data['email'];
        } else {
         _emailController.text = '';
        }
        if (data['phone_number'] != null) {
          _phoneController.text = data['phone_number'];
        } else {
          _phoneController.text = '';
        }
        if (data['address'] != null) {
          _addressController.text = data['address'];
        } else {
          _addressController.text = '';
        }
        if (data['birth_date'] != null) {
          _birthDateController.text = data['birth_date'];
        } else {
          _birthDateController.text = '';
        }
        if (data['gender'] != null) {
          _genderController.text = data['gender'];
        } else {
          _genderController.text = '';
        }

        if (data['specialization'] != null) {
          _specializationController.text = data['specialization'];
        } else {
          _specializationController.text = '';
        }

        if (data['salary'] != null) {
          _salaryController.text = data['salary'].toString();
        } else {
          _salaryController.text = '';
        }
        _teacherinfo = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The teacher is not found')),
      );
      setState(() {
        _teacherinfo = false;
      });
    }
  }

  Future<void> _updateTeacherData() async {
    final id = _teacherIdController.text;
    if (_formKey.currentState!.validate()) {
      await _database.child('teachers/$id').update({
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'email': _emailController.text,
        'phone_number': _phoneController.text,
        'address': _addressController.text,
        'birth_date': _birthDateController.text,
        'gender': _genderController.text,
        'specialization': _specializationController.text,
        'salary': _salaryController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The Teacher Information Updated Successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text('Update Teacher Information')),
      body: Padding(
        padding:  EdgeInsets.all(16),
        child: Column(
    children: [
            TextFormField(
              controller: _teacherIdController,
              decoration:  InputDecoration(labelText: 'Teacher_id',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),),
                prefixIcon: Icon(Icons.person)
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadTeacherData,
              child:  Text('Loading Teacher information'),
            ),
             SizedBox(height: 16),
            if (_teacherinfo)
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: _firstNameController,
                        decoration:  InputDecoration(labelText: 'First_Name',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),),
                            prefixIcon: Icon(Icons.person)
                        ),
                        validator: (value) {
                          if(value==null||value.isEmpty) {
                            return "Enter the First Name";
                          }
                          else
                            return null;
                        }
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(labelText: 'Last Name',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),),
                            prefixIcon: Icon(Icons.person)
                        ),
                          validator: (value) {
                            if(value==null||value.isEmpty) {
                              return "Enter the Last Name";
                            }
                            else
                              return null;
                          }
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'email',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),),
                            prefixIcon: Icon(Icons.email)
                        ),
                          validator: (value) {
                            if(value==null||value.isEmpty) {
                              return "Enter email";
                            }
                            else
                              return null;
                          }
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration:  InputDecoration(labelText: 'phone Number',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),),
                            prefixIcon: Icon(Icons.phone)
                        ),
                          validator: (value) {
                            if(value==null||value.isEmpty) {
                              return "Enter phone Number";
                            }
                            else
                              return null;
                          }
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _addressController,
                        decoration:  InputDecoration(labelText: 'Address',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),),
                            prefixIcon: Icon(Icons.home)
                        ),
                          validator: (value) {
                            if(value==null||value.isEmpty) {
                              return "Enter Address";
                            }
                            else
                              return null;
                          }
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _birthDateController,
                        decoration:  InputDecoration(labelText: 'Birth Date',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),),
                            prefixIcon: Icon(Icons.calendar_month_sharp)
                        ),
                          validator: (value) {
                            if(value==null||value.isEmpty) {
                              return "Enter Birth Date";
                            }
                            else
                              return null;
                          }
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _genderController,
                        decoration: InputDecoration(labelText: 'gender',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),),
                            prefixIcon: Icon(Icons.person)
                        ),
                          validator: (value) {
                            if(value==null||value.isEmpty) {
                              return "Enter gender";
                            }
                            else
                              return null;
                          }
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _specializationController,
                        decoration:  InputDecoration(labelText: 'specialize',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),),

                        ),
                          validator: (value) {
                            if(value==null||value.isEmpty) {
                              return "Enter specialization";
                            }
                            else
                              return null;
                          }
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _salaryController,
                        decoration:  InputDecoration(labelText: 'salary',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),),
                            prefixIcon: Icon(Icons.money)
                        ),
                          validator: (value) {
                            if(value==null||value.isEmpty) {
                              return "Enter the salary";
                            }
                            else
                              return null;
                          }
                      ),
                       SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _updateTeacherData,
                        child:  Text('Update'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
