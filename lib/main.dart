import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final List<Task> tasks = [
    Task(title: "Wash the dishes", deadline: "Today"),
    Task(title: "Walk the dog", deadline: "Tomorrow"),
    Task(title: "Take out the trash", deadline: "This month"),
    Task(title: "Take a shower", deadline: "This week")
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CrackFlow',
      home: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return Text(tasks[index].title);
          }
      ),
    );
  }
}

class Task {
  final String title;
  final String deadline;

  Task({required this.title, required this.deadline});
}
