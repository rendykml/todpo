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
  String selectedFilter = "all";

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final token = await TokenStorage.getToken();
      if (token != null && mounted) {
        context.read<TaskController>().loadTasks(token);
      }
    });
  }

  String subTitle() {
    return "Manage Tasks";
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final controller = context.watch<TaskController>();

    return Scaffold(
      backgroundColor: dark ? Colors.black : Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= PREMIUM APPBAR =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(subTitle()),
                      Text(
                        "Your Tasks",
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  CircleAvatar(
                    backgroundColor: dark ? Colors.white : Colors.black,
                    child: IconButton(
                      icon: Icon(
                        Icons.logout,
                        color: dark ? Colors.black : Colors.white,
                      ),
                      onPressed: () async {
                        await TokenStorage.deleteToken();
                        if (!context.mounted) return;

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ================= FILTER =================
              _buildFilter(),

              const SizedBox(height: 20),

              Expanded(child: _buildBody(controller)),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
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

  // ================= FILTER WIDGET =================
  Widget _buildFilter() {
    return Row(
      children: [
        _filterChip("All", "all"),
        _filterChip("Completed", "done"),
        _filterChip("Ongoing", "pending"),
      ],
    );
  }

  Widget _filterChip(String label, String value) {
    final selected = selectedFilter == value;

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) {
          setState(() {
            selectedFilter = value;
          });
        },
      ),
    );
  }

  // ================= BODY =================
  Widget _buildBody(TaskController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    List filteredTasks = controller.tasks.where((task) {
      if (selectedFilter == "done") {
        return task.status == "completed";
      }

      if (selectedFilter == "pending") {
        return task.status == "ongoing";
      }

      return true;
    }).toList();

    if (filteredTasks.isEmpty) {
      return const Center(child: Text("No tasks found."));
    }

    return ListView.builder(
      itemCount: filteredTasks.length,
      itemBuilder: (_, index) {
        return TaskCard(task: filteredTasks[index]);
      },
    );
  }
}
