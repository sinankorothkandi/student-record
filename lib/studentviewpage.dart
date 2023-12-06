// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'package:flutter/material.dart';
import 'databace.dart';
import 'datastoring.dart';
import 'edit.dart';

class PreviewStudentPage extends StatelessWidget {
  final Student student;
  final DatabaseHelper dbHelper;

  PreviewStudentPage({required this.student, required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(student.name),
        backgroundColor: Colors.blueGrey[800],
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditStudentPage(
                      student: student,
                      dbHelper: dbHelper,
                    ),
                  ),
                );
              },
              icon: Icon(Icons.edit)),
          IconButton(
              onPressed: () async {
                await dbHelper.deleteStudent(student.id!);
                Navigator.pop(context);
              },
              icon: Icon(Icons.delete))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: FileImage(File(student.profilePicture)),
            ),
            const SizedBox(height: 20),
            Text('Name: ${student.name}', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Age: ${student.age}', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Class: ${student.classs}', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Father: ${student.father}', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
