class Task {
  final int id;
  final String title;
  final String deadline;
  final String priority;
  bool done;

  Task({
    required this.id,
    required this.title,
    required this.deadline,
    required this.priority,
    required this.done,
  });
}