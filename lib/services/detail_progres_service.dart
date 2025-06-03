import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sikermatsu/models/detail_progres.dart';
import 'auth_service.dart';

class DetailProgressService {
  static const String baseUrl = "http://192.168.18.248:8000/api";
  static String? token;
  static String? role;

  static Future<DetailProgress> addProgress({
    required int mouId,
    required String tanggal,
    required String aktivitas,
    required String proses,
  }) async {
    final token = await AuthService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/addProgress/$mouId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'tanggal': tanggal,
        'proses': proses,
        'aktivitas': aktivitas,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return DetailProgress.fromJson(data['data']);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Gagal menambahkan progres');
    }
  }
}
