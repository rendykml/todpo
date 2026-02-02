import 'dart:convert';
import '../models/task_model.dart';
import '../../config/api_config.dart';
import 'api_services.dart';

class TaskService {
  static Future<List<Task>> fetchTasks(String token) async {
    final response = await ApiService.get(
      "${ApiConfig.baseUrl}/tasks",
      token: token,
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil task");
    }
  }

  static Future<void> createTask(
    String token,
    Map<String, dynamic> data,
  ) async {
    await ApiService.post(
      "${ApiConfig.baseUrl}/tasks",
      token: token,
      body: data,
    );
  }

  static Future<void> updateTask(
    String token,
    String taskId,
    Map<String, dynamic> data,
  ) async {
    final response = await ApiService.put(
      "${ApiConfig.baseUrl}/tasks/$taskId",
      token: token,
      body: data,
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal update task");
    }
  }

  static Future<void> deleteTask(String token, String taskId) async {
    final response = await ApiService.delete(
      "${ApiConfig.baseUrl}/tasks/$taskId",
      token: token,
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal menghapus task");
    }
  }
}
