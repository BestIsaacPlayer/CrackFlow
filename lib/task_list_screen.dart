import 'package:crack_flow/main.dart';
import 'package:crack_flow/models/task.dart';
import 'package:crack_flow/services/task_local_database.dart';
import 'package:crack_flow/services/task_sync_service.dart';
import 'package:crack_flow/task_repository.dart';
import 'package:flutter/material.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Future<List<Task>> tasksFuture;

  @override
  void initState() {
    super.initState();
    tasksFuture = loadTasks();
  }

  Future<List<Task>> loadTasks() async {
    await TaskSyncService.loadInitialDataIfNeeded();
    return TaskLocalDatabase.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    List<Task> filteredTasks = TaskRepository.tasks;

    if (TaskRepository.selectedFilter == "Done") {
      filteredTasks = TaskRepository.tasks.where((task) => task.done).toList();
    } else if (TaskRepository.selectedFilter == "To Do") {
      filteredTasks = TaskRepository.tasks.where((task) => !task.done).toList();
    }

    return FutureBuilder<List<Task>>(
      future: tasksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final tasks = snapshot.data ?? [];
        TaskRepository.tasks.addAll(tasks);
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            var task = filteredTasks[index];
            return Dismissible(
              key: ValueKey(task.title),
              direction: DismissDirection.startToEnd,
              onDismissed: (direction) {
                setState(() {
                  TaskRepository.tasks.remove(task);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Task ${task.title} has been removed!"),
                  ),
                );
              },
              child: TaskCard(
                title: task.title,
                deadline: task.deadline,
                priority: task.priority,
                done: task.done,
                onChanged: (value) {
                  setState(() {
                    task.done = value!;
                  });
                },
                onTap: () async {
                  final Task? updatedTask = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditTaskScreen(task: task),
                    ),
                  );

                  if (updatedTask != null) {
                    setState(() {
                      TaskRepository.tasks[index] = updatedTask;
                    });
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
