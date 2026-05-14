import 'package:crack_flow/main.dart';
import 'package:crack_flow/models/task.dart';
import 'package:crack_flow/services/task_local_database.dart';
import 'package:crack_flow/task_repository.dart';
import 'package:flutter/material.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    List<Task> filteredTasks = TaskRepository.tasks;

    if (TaskRepository.selectedFilter == "Done") {
      filteredTasks = TaskRepository.tasks.where((task) => task.done).toList();
    } else if (TaskRepository.selectedFilter == "To Do") {
      filteredTasks = TaskRepository.tasks.where((task) => !task.done).toList();
    }

    if (filteredTasks.isEmpty) {
      return const Center(child: Text("No tasks found."));
    }

    return ListView.builder(
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        var task = filteredTasks[index];
        return Dismissible(
          key: ValueKey(task.id),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) async {
            await TaskLocalDatabase.deleteTask(task.id);
            setState(() {
              TaskRepository.tasks.removeWhere((listTask) => listTask.id == task.id);
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
            onChanged: (value) async {
              final updatedTask = Task(
                id: task.id,
                title: task.title,
                deadline: task.deadline,
                priority: task.priority,
                done: value ?? false,
              );

              await TaskLocalDatabase.updateTask(updatedTask);

              setState(() {
                int repoIndex = TaskRepository.tasks.indexWhere((t) => t.id == task.id);
                if (repoIndex != -1) {
                  TaskRepository.tasks[repoIndex] = updatedTask;
                }
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
                await TaskLocalDatabase.updateTask(updatedTask);

                setState(() {
                  int repoIndex = TaskRepository.tasks.indexWhere((listTask) => listTask.id == task.id);
                  if (repoIndex != -1) {
                    TaskRepository.tasks[repoIndex] = updatedTask;
                  }
                });
              }
            },
          ),
        );
      },
    );
  }
}
