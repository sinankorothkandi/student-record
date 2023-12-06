// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'databace.dart';
import 'datastoring.dart';

class AddStudentPage extends StatefulWidget {
  final DatabaseHelper dbHelper;

  AddStudentPage({required this.dbHelper});

  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _fatherController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _imageFile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final XFile? selected = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      _imageFile = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
          
            key: _formKey, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_imageFile != null) ...[
                  SizedBox(height: 60),
                  ClipOval(
                    child: Image.file(
                      File(_imageFile!.path),
                      width: 90,
                      height: 90,
                    ),
                  ),
                  const SizedBox(height: 20),
                ] else ...[
                  SizedBox(height: 60),
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueGrey[800],
                    ),
                    child: IconButton(
                      onPressed: () {
                        _pickImage();
                      },
                      icon: Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 47),
                ],
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a age';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    controller: _classController,
                    decoration: const InputDecoration(labelText: 'Class'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a class';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    controller: _fatherController,
                    decoration: const InputDecoration(labelText: 'father'),
                  
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a father';
                      }  
                      return null;
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(controller: TextEditingController(),
                decoration: InputDecoration(labelText: 'place'),),
              ),
                const SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 120),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final student = Student(
                          name: _nameController.text,
                          age: int.parse(_ageController.text),
                          profilePicture: _imageFile!.path,
                          classs: int.parse(_classController.text),
                          father: _fatherController.text,
                       
                        );

                        try {
                          await DatabaseHelper.insertStudent(student);
                          Navigator.pop(context);
                        } catch (e) {
                          print("Error inserting student: $e");
                        
                        }
                      }
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
