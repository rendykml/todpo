import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/token_storage.dart';
import '../widgets/stats_card.dart';
import '../stats_controller.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final token = await TokenStorage.getToken();
      final userId = await TokenStorage.getUserId();

      if (token != null && userId != null && mounted) {
        context.read<StatsController>().loadStats(token: token, userId: userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<StatsController>();

    return Scaffold(
      body: SafeArea(
        child: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : controller.stats == null
            ? const Center(child: Text("No statistics available yet"))
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ===== HEADER (Match Home Style)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Focus Overview",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          "Your Statistics",
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// ===== GRID STATS
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: [
                          StatsCard(
                            title: "Today",
                            value: "${controller.stats!.daily} Cycles",
                            icon: Icons.today,
                          ),

                          StatsCard(
                            title: "This Week",
                            value: "${controller.stats!.weekly} Cycles",
                            icon: Icons.date_range,
                          ),

                          StatsCard(
                            title: "This Month",
                            value: "${controller.stats!.monthly} Cycles",
                            icon: Icons.calendar_month,
                          ),

                          StatsCard(
                            title: "Daily Average",
                            value:
                                "${controller.stats!.average.toStringAsFixed(1)} / Day",
                            icon: Icons.trending_up,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
