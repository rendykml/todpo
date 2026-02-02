import '../../config/api_config.dart';
import 'api_services.dart';

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
}
