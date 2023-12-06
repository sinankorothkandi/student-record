import 'dart:io';
import 'package:flutter/material.dart';
import 'databace.dart';
import 'datastoring.dart';

class EditStudentPage extends StatefulWidget {
  final Student student;
  final DatabaseHelper dbHelper;

  EditStudentPage({required this.student, required this.dbHelper});

  @override
  _EditStudentPageState createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _fatherController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.student.name;
    _ageController.text = widget.student.age.toString();
    _classController.text = widget.student.classs.toString();
    _fatherController.text = widget.student.father;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Student'),
        backgroundColor: Colors.blueGrey[800],
        actions: [
          IconButton(
              onPressed: () async {
                await widget.dbHelper.deleteStudent(widget.student.id!);
                Navigator.pop(context);
              },
              icon: Icon(Icons.delete))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 60,
              ),
              CircleAvatar(
                radius: 50,
                backgroundImage: FileImage(File(widget.student.profilePicture)),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _classController,
                decoration: const InputDecoration(labelText: 'Class'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _fatherController,
                decoration: const InputDecoration(labelText: 'father'),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 80),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_nameController.text.isNotEmpty &&
                        _ageController.text.isNotEmpty &&
                        _classController.text.isNotEmpty &&
                        _fatherController.text.isNotEmpty) {
                      final updatedStudent = Student(
                        id: widget.student.id,
                        name: _nameController.text,
                        age: int.parse(_ageController.text),
                        profilePicture: widget.student.profilePicture,
                        classs: int.parse(_classController.text),
                        father: _fatherController.text,
                        
                      );

                      await widget.dbHelper.updateStudent(updatedStudent);
                      setState(() {
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: const Text('Update'),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );

  }
}
