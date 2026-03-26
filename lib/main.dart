import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final List<Task> tasks = [
    Task(title: "Wash the dishes", deadline: "Today", done: true, priority: "High"),
    Task(title: "Walk the dog", deadline: "Tomorrow", done: true, priority: "Medium"),
    Task(title: "Take out the trash", deadline: "This month", done: false, priority: "High"),
    Task(title: "Take a shower", deadline: "This week", done: false, priority: "Low")
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'CrackFlow',
        home: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("You have ${tasks.where((task) => task.done).length} tasks to do today!"),
            SizedBox(height: 16),
            Text("Your tasks for today:"),
            Expanded(child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  var task = tasks[index];
                  return TaskCard(title: task.title, subtitle: "Deadline: ${task.deadline} | Priority: ${task.priority}", icon: task.done ? Icons.check_circle : Icons.radio_button_unchecked);
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
  final bool done;
  final String priority;

  Task({required this.title, required this.deadline, required this.done, required this.priority});
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
