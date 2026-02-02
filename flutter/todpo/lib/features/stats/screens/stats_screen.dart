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
      appBar: AppBar(title: const Text("Statistik Fokus")),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.stats == null
          ? const Center(child: Text("Belum ada data statistik"))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  StatsCard(
                    title: "Hari Ini",
                    value: "${controller.stats!.daily} cycle",
                    icon: Icons.today,
                  ),
                  StatsCard(
                    title: "Minggu Ini",
                    value: "${controller.stats!.weekly} cycle",
                    icon: Icons.date_range,
                  ),
                  StatsCard(
                    title: "Bulan Ini",
                    value: "${controller.stats!.monthly} cycle",
                    icon: Icons.calendar_month,
                  ),
                  StatsCard(
                    title: "Rata-rata",
                    value:
                        "${controller.stats!.average.toStringAsFixed(1)} / hari",
                    icon: Icons.trending_up,
                  ),
                ],
              ),
            ),
    );
  }
}
