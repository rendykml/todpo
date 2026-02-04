import '../../config/api_config.dart';
import 'api_services.dart';
import 'dart:convert';

class SessionService {
  static Future<void> createSession({
    required String token,
    required String taskId,
    required int cycleNumber,
    required String type,
    required int duration,
    required String status,
  }) async {
    final response = await ApiService.post(
      "${ApiConfig.baseUrl}/sessions",
      token: token,
      body: {
        "taskId": taskId,
        "cycle_number": cycleNumber,
        "type": type,
        "durasi": duration,
        "status": status,
      },
    );

    if (response.statusCode != 201) {
      throw Exception("Gagal menyimpan session pomodoro");
    }
  }

  // ================= FETCH SESSION =================
  static Future<List<dynamic>> fetchSessions(String token) async {
    final response = await ApiService.get(
      "${ApiConfig.baseUrl}/sessions",
      token: token,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal mengambil session");
    }
  }
}
