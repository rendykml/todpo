import 'package:flutter/material.dart';
import '../../models/stats_model.dart';
import '../../services/stats_services.dart';

class StatsController extends ChangeNotifier {
  FocusStats? stats;
  bool isLoading = false;

  Future<void> loadStats({
    required String token,
    required String userId,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      stats = await StatsService.fetchStats(token: token, userId: userId);

      debugPrint("STATS LOADED:");
      debugPrint("DAILY: ${stats!.daily}");
      debugPrint("WEEKLY: ${stats!.weekly}");
      debugPrint("MONTHLY: ${stats!.monthly}");
      debugPrint("AVG: ${stats!.average}");
    } catch (e) {
      debugPrint("STATS ERROR: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
