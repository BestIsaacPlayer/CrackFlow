import 'dart:convert';
import 'package:crack_flow/task_repository.dart';
import 'package:http/http.dart' as http;

class TaskApiService {
  static const String baseUrl = "https://dummyjson.com";

  static Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse("$baseUrl/todos"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List todos = data["todos"];
      return todos.map((todo) {
        return Task(
          title: todo["todo"],
          deadline: "None",
          done: todo["completed"],
          priority: "Medium",
        );
      }).toList();
    } else {
      throw Exception("Exception when getting data!");
    }
  }
}
