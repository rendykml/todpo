import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // GET
  static Future<http.Response> get(String url, {required String token}) async {
    return http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  static Future<http.Response> post(
    String url, {
    required String token,
    required Map<String, dynamic> body,
  }) async {
    return http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> put(
    String url, {
    required String token,
    required Map<String, dynamic> body,
  }) async {
    return http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> delete(
    String url, {
    required String token,
  }) async {
    return http.delete(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}
