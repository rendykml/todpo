import 'package:flutter/material.dart';
import '../../../models/task_model.dart';
import '../screens/task_detail_screen.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final progress = task.completedCycle / task.targetCycle;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskDetailScreen(
              taskId: task.id, 
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text("Schedule: ${task.scheduleType}"),
              Text("Cycle: ${task.completedCycle} / ${task.targetCycle}"),
              const SizedBox(height: 6),
              LinearProgressIndicator(value: progress.clamp(0, 1)),
            ],
          ),
        ),
      ),
    );
  }
}
