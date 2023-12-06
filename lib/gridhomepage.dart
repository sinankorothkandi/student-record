// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rec/edit.dart';
import 'package:rec/studentadd.dart';
import 'package:rec/studentviewpage.dart';
import 'databace.dart';
import 'datastoring.dart';
import 'listhomepage.dart';

class GridHomePage extends StatefulWidget {
  const GridHomePage({Key? key}) : super(key: key);

  @override
  _GridHomePageState createState() => _GridHomePageState();
}

class _GridHomePageState extends State<GridHomePage> {
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
                    labelStyle: TextStyle(color: Colors.white),
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
                    builder: (_) => const ListHomePage(),
                  ),
                );
              },
              icon: const Icon(Icons.list),
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
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: isSearchVisible ? searchResults.length : students.length,
          itemBuilder: (context, index) {
            final student =
                isSearchVisible ? searchResults[index] : students[index];
            return Card(
                elevation: 4,
                margin: const EdgeInsets.all(10),
                child: InkWell(
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
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              FileImage(File(student.profilePicture)),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          student.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text('Class: ${student.classs}'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .center, 
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
                                return showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Alert'),
                                      content: Text(
                                          'Are you sure you want to delete?'),
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
                                          child: Text('Yes'),
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
                      ]),
                ));
          },
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
