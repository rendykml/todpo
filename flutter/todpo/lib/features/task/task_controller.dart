import 'package:flutter/material.dart';
import '../../models/task_model.dart';
import '../../services/task_services.dart';

class TaskController extends ChangeNotifier {
  List<Task> tasks = [];
  bool isLoading = false;

  Future<void> loadTasks(String token) async {
    isLoading = true;
    notifyListeners();

    try {
      tasks = await TaskService.fetchTasks(token);
    } catch (e) {
      debugPrint(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> addTask({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    await TaskService.createTask(token, data);
    await loadTasks(token);
  }

  Future<void> updateTask({
    required String token,
    required String taskId,
    required Map<String, dynamic> data,
  }) async {
    await TaskService.updateTask(token, taskId, data);
    await loadTasks(token);
  }

  Future<void> deleteTask({
    required String token,
    required String taskId,
  }) async {
    await TaskService.deleteTask(token, taskId);
    await loadTasks(token);
  }
}
