import 'dart:convert';
import 'package:crack_flow/task_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class TaskApiService {
  static const String baseUrl = "https://dummyjson.com";

  static final priorities = ["Low", "Medium", "High"];
  static final deadlines = ["Today", "Tomorrow", "A Week", "A Month", "A Year"];
  static final random = Random();

  static Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse("$baseUrl/todos"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List todos = data["todos"];
      return todos.map((todo) {
        return Task(
          title: todo["todo"],
          deadline: deadlines[random.nextInt(deadlines.length)],
          done: todo["completed"],
          priority: priorities[random.nextInt(priorities.length)]
        );
      }).toList();
    } else {
      throw Exception("Exception when getting data!");
    }
  }
}
