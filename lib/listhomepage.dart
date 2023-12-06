// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rec/edit.dart';
import 'package:rec/studentadd.dart';
import 'package:rec/studentviewpage.dart';
import 'databace.dart';
import 'datastoring.dart';
import 'gridhomepage.dart';

class ListHomePage extends StatefulWidget {
  const ListHomePage({Key? key}) : super(key: key);

  @override
  _ListHomePageState createState() => _ListHomePageState();
}

class _ListHomePageState extends State<ListHomePage> {
  bool isSearchVisible = false;
  TextEditingController searchController = TextEditingController();
  late List<Student> students;
  late List<Student> searchResults;
  late DatabaseHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    students = [];
    searchResults = [];
    refreshStudentList();
  }

  Future<void> refreshStudentList() async {
    students = await DatabaseHelper.getAllStudents();
    setState(() {});
  }

  Future<void> searchStudents(String query) async {
    searchResults = await DatabaseHelper.searchStudents(query);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[800],
          toolbarHeight: 65,
          title: isSearchVisible
              ? TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search..',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onChanged: (value) {
                    searchStudents(value);
                  },
                )
              : const Text('Recorder'),
          actions: [
            isSearchVisible
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isSearchVisible = false;
                        searchController.clear();
                        searchResults.clear();
                      });
                    },
                    icon: const Icon(Icons.navigate_before),
                  )
                : IconButton(
                    onPressed: () {
                      setState(() {
                        isSearchVisible = true;
                      });
                    },
                    icon: const Icon(Icons.search_outlined),
                  ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GridHomePage(),
                  ),
                );
              },
              icon: const Icon(Icons.grid_view),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueGrey[800],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.black38,
                      foregroundColor: Color.fromARGB(255, 233, 233, 233),
                      child: Icon(Icons.person_2),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Welcome Mr. John',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )
                  ],
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                },
                title: const Text('Profile'),
                leading: const Icon(Icons.person_outline),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                },
                title: const Text('Settings'),
                leading: const Icon(Icons.settings_outlined),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                },
                title: const Text('Logout'),
                leading: const Icon(Icons.logout),
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount:
                    isSearchVisible ? searchResults.length : students.length,
                itemBuilder: (context, index) {
                  final student =
                      isSearchVisible ? searchResults[index] : students[index];
                  return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      child: Container(
                        height: 65,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PreviewStudentPage(
                                  student: student,
                                  dbHelper: dbHelper,
                                ),
                              ),
                            ).then((value) {
                              refreshStudentList();
                            });
                          },
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                FileImage(File(student.profilePicture)),
                          ),
                          title: Text(student.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => EditStudentPage(
                                              student: student,
                                              dbHelper: dbHelper)));
                                },
                                icon: Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Delete Student'),
                                        content: Text(
                                            'Are you sure you want to delete ${student.name}?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await dbHelper
                                                  .deleteStudent(student.id!);
                                              refreshStudentList();
                                              Navigator.pop(context);
                                            },
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      ));
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddStudentPage(
                  dbHelper: dbHelper,
                ),
              ),
            ).then((value) {
              refreshStudentList();
            });
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.blueGrey[800],
        ),
      ),
    );
  }
}
