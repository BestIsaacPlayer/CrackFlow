class Task {
  final String title;
  final String deadline;
  final bool done;
  final String priority;

  Task({
    required this.title,
    required this.deadline,
    required this.done,
    required this.priority,
  });
}

class TaskRepository {
  static List<Task> tasks = [
    Task(
      title: "Wash the dishes",
      deadline: "Today",
      done: true,
      priority: "High",
    ),
    Task(
      title: "Walk the dog",
      deadline: "Tomorrow",
      done: true,
      priority: "Medium",
    ),
    Task(
      title: "Take out the trash",
      deadline: "This month",
      done: false,
      priority: "High",
    ),
    Task(
      title: "Take a shower",
      deadline: "This week",
      done: false,
      priority: "Low",
    ),
  ];
}
