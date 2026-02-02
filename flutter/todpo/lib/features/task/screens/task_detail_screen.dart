import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/task_model.dart';
import '../../../utils/token_storage.dart';
import '../task_controller.dart';
import 'edit_task_screen.dart';
import '../../pomodoro/screens/pomodoro_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TaskController>();

    final task = controller.tasks.firstWhere((t) => t.id == taskId);

    final progress = task.completedCycle / task.targetCycle;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Detail"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditTaskScreen(task: task)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmation(context, task);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Judul
            Text(
              task.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Deskripsi
            Text(task.description ?? "-", style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 16),

            // Jadwal
            _infoRow("Schedule Type", task.scheduleType),
            _infoRow("Start Date", task.startDateFormatted),
            _infoRow("Deadline", task.deadlineFormatted),

            const Divider(height: 32),

            // Cycle Progress
            Text(
              "Progress Cycle",
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 8),

            Text(
              "${task.completedCycle} / ${task.targetCycle} Cycle",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 6),

            LinearProgressIndicator(value: progress.clamp(0, 1)),

            const Divider(height: 32),

            // Tambahan
            _infoRow("Priority", task.priority),
            _infoRow("Visibility", task.visibility),
            _infoRow("Status", task.status),

            const SizedBox(height: 32),

            // Button Pomodoro
            ElevatedButton.icon(
              icon: const Icon(Icons.timer),
              label: const Text("Mulai Pomodoro"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PomodoroScreen(task: task)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Task"),
        content: const Text("Apakah kamu yakin ingin menghapus task ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              final token = await TokenStorage.getToken();
              if (token == null) return;

              await context.read<TaskController>().deleteTask(
                token: token,
                taskId: task.id,
              );

              if (!context.mounted) return;

              Navigator.pop(ctx); // tutup dialog
              Navigator.pop(context); // kembali ke task list
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
