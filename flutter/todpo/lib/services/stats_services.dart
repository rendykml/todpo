import 'dart:convert';
import '../../config/api_config.dart';
import 'api_services.dart';
import '../models/stats_model.dart';

class StatsService {
  static Future<FocusStats> fetchStats({
    required String token,
    required String userId,
  }) async {
    final response = await ApiService.get(
      "${ApiConfig.baseUrl}/users/$userId/stats",
      token: token,
    );

    if (response.statusCode == 200) {
      return FocusStats.fromJson(json.decode(response.body));
    } else {
      throw Exception("Gagal mengambil statistik");
    }
  }
}
