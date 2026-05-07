class Task {
  final String title;
  final String deadline;
  bool done;
  final String priority;

  Task({
    required this.title,
    required this.deadline,
    required this.done,
    required this.priority,
  });
}

class TaskRepository {
  static List<Task> tasks = [];

  static String filter = "All";
  static String selectedFilter = "All";
}
