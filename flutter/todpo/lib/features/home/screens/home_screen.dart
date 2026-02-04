import 'dart:ui';
import 'package:flutter/material.dart';
import '../../authentication/screens/login/login.dart';
import '../../../utils/token_storage.dart';
import '../../../services/task_services.dart';
import '../../../models/task_model.dart';
import '../../../services/session_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<Task> tasks = [];
  bool isLoading = true;
  int totalFocusMinutes = 0;

  Future<void> loadDashboard() async {
    try {
      final token = await TokenStorage.getToken();

      if (token == null) return;

      final fetchedTasks = await TaskService.fetchTasks(token);

      setState(() {
        tasks = fetchedTasks;
        isLoading = false;
      });

      calculateFocus(token);
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> calculateFocus(String token) async {
    final sessions = await SessionService.fetchSessions(token);

    int total = 0;

    for (var session in sessions) {
      if (session["type"] == "focus" && session["status"] == "completed") {
        total += session["durasi"] as int;
      }
    }

    setState(() {
      totalFocusMinutes = total;
    });
  }

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: const Text("Logout"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await TokenStorage.deleteToken();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    loadDashboard();
  }

  String greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) return "Good Morning ☀️";
    if (hour < 17) return "Good Afternoon 🌤";
    return "Good Evening 🌙";
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= GREETING =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // LEFT SIDE TEXT
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            greeting(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            "Stay Focused",
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      // RIGHT SIDE LOGOUT
                      CircleAvatar(
                        backgroundColor: dark
                            ? const Color.fromARGB(255, 255, 255, 255)
                            : const Color.fromARGB(255, 0, 0, 0),
                        child: IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () => _logout(context),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // ================= PROGRESS RING =================
                  Center(
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (_, __) {
                        return _ProgressRing(progress: controller.value);
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ================= FLOATING GLASS CARDS =================
                  Row(
                    children: [
                      Expanded(
                        child: _glassStat("Tasks", tasks.length.toString()),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _glassStat(
                          "Focus",
                          "${totalFocusMinutes ~/ 60}h ${totalFocusMinutes % 60}m",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "Today's Tasks",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 12),

                  Expanded(
                    child: ListView(
                      children: tasks
                          .map((task) => _TaskTile(title: task.title))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= GLASS STAT =================
  Widget _glassStat(String title, String value) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 51, 48, 48).withOpacity(0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  // ================= BLUR BACKGROUND BLOB =================
}

// ================= PROGRESS RING =================
class _ProgressRing extends StatelessWidget {
  final double progress;

  const _ProgressRing({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 180,
          height: 180,
          child: CircularProgressIndicator(value: progress, strokeWidth: 8),
        ),
        const Text("Focus", style: TextStyle(fontSize: 20)),
      ],
    );
  }
}

// ================= TASK TILE =================
class _TaskTile extends StatelessWidget {
  final String title;

  const _TaskTile({required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.check_circle_outline),
      title: Text(title),
    );
  }
}
