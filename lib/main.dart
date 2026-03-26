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
        home: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("You have ${tasks.length} tasks to do today!"),
            SizedBox(height: 16),
            Text("Your tasks for today:"),
            Expanded(child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return TaskCard(title: tasks[index].title, subtitle: "Deadline: ${tasks[index].deadline}", icon: Icons.favorite);
                }
            ))
          ],
        )
    );
  }
}

class Task {
  final String title;
  final String deadline;

  Task({required this.title, required this.deadline});
}

class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const TaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          child: ListTile(
            leading: Icon(icon),
            title: Text(title),
            subtitle: Text(subtitle),
          ),
        ));
  }
}
