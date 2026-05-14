import 'dart:math';

import 'package:crack_flow/models/task.dart';
import 'package:crack_flow/services/task_local_database.dart';
import 'package:crack_flow/task_list_screen.dart';
import 'package:crack_flow/task_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox("tasks");

  TaskRepository.tasks = TaskLocalDatabase.getTasks();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'CrackFlow', home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CrackFlow"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              if (TaskRepository.tasks.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Task list is empty!"),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Confirmation"),
                      content: Text(
                          "Are you sure that you want to delete all tasks?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              TaskRepository.tasks.clear();
                            });
                            Navigator.pop(context);
                          },
                          child: Text("Delete"),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "You have ${TaskRepository.tasks.where((task) => !task.done).length} tasks to do today!",
            ),
            SizedBox(height: 16),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      TaskRepository.selectedFilter = "All";
                    });
                  },
                  child: Text("All"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      TaskRepository.selectedFilter = "To Do";
                    });
                  },
                  child: Text("To Do"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      TaskRepository.selectedFilter = "Done";
                    });
                  },
                  child: Text("Done"),
                ),
              ],
            ),
            Text("Your tasks for today:"),
            Expanded(
              child: TaskListScreen()
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Task? newTask = await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  AddTaskScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    final offsetAnimation = Tween<Offset>(
                      begin: Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
            ),
          );
          if (newTask != null) {
            setState(() {
              TaskRepository.tasks.add(newTask);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String deadline;
  final String priority;
  final bool done;
  final ValueChanged<bool?>? onChanged;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.title,
    required this.deadline,
    required this.priority,
    required this.done,
    this.onChanged,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Card(
        child: ListTile(
          onTap: onTap,
          leading: Checkbox(
            value: done,
            onChanged: onChanged,
          ),
          title: Text(
            title,
            style: TextStyle(
                decoration: done
                    ? TextDecoration.lineThrough
                    : TextDecoration.none
            ),
          ),
          subtitle: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(text: "Deadline: $deadline | Priority: "),
                  TextSpan(
                    text: priority,
                    style: TextStyle(
                      color: priority == "Low" ? Colors.green : priority == "Medium" ? Colors.yellow : priority == "High" ? Colors.red : Colors.black
                    )
                  )
                ]
              )
          ),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({super.key});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Task")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Task Title",
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: deadlineController,
              decoration: InputDecoration(
                labelText: "Task Deadline",
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: priorityController,
              decoration: InputDecoration(
                labelText: "Task Priority",
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final newTask = Task(
                  id: Random().nextInt(1000000),
                  title: titleController.text,
                  deadline: deadlineController.text,
                  priority: priorityController.text,
                  done: false
                );
                Navigator.pop(context, newTask);
              },
              child: Text("Save Task"),
            ),
          ],
        ),
      ),
    );
  }
}

class EditTaskScreen extends StatelessWidget {
  EditTaskScreen({super.key, required this.task});

  final Task task;

  late final TextEditingController titleController = TextEditingController(text: task.title);
  late final TextEditingController deadlineController = TextEditingController(text: task.deadline);
  late final TextEditingController priorityController = TextEditingController(text: task.priority);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Task")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Task Title",
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: deadlineController,
              decoration: InputDecoration(
                labelText: "Task Deadline",
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: priorityController,
              decoration: InputDecoration(
                labelText: "Task Priority",
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final newTask = Task(
                  id: task.id,
                  title: titleController.text,
                  deadline: deadlineController.text,
                  priority: priorityController.text,
                  done: false
                );
                Navigator.pop(context, newTask);
              },
              child: Text("Save Task"),
            ),
          ],
        ),
      ),
    );
  }
}
