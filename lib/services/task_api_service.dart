import 'dart:convert';
import 'package:crack_flow/models/task.dart';
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
          id: Random().nextInt(1000000),
          title: todo["todo"],
          deadline: deadlines[random.nextInt(deadlines.length)],
          priority: priorities[random.nextInt(priorities.length)],
          done: todo["completed"]
        );
      }).toList();
    } else {
      throw Exception("Exception when getting data!");
    }
  }
}
