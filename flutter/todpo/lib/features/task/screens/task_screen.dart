import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';

import '../../authentication/screens/login/login.dart';
import '../../../utils/token_storage.dart';
import '../task_controller.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    super.initState();

    // Load task setelah screen siap
    Future.microtask(() async {
      final token = await TokenStorage.getToken();
      if (token != null && mounted) {
        context.read<TaskController>().loadTasks(token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final controller = context.watch<TaskController>();

    return Scaffold(
      backgroundColor: dark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text('Tasks'),

        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await TokenStorage.deleteToken();
              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildBody(controller),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
        },
        child: const Icon(Iconsax.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBody(TaskController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.tasks.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada task.\nYuk buat task pertamamu 🚀',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      itemCount: controller.tasks.length,
      itemBuilder: (context, index) {
        return TaskCard(task: controller.tasks[index]);
      },
    );
  }
}
