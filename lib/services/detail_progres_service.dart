import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sikermatsu/models/detail_progres.dart';
import 'auth_service.dart';
import '../constants/api_constants.dart';

class DetailProgressService {
  // static const String baseUrl = "http://192.168.100.238:8000/api";
  static String? token;
  static String? role;
  static Future<DetailProgress> addProgress({
    required int id,
    required String tanggal,
    required String aktivitas,
    required String proses,
  }) async {
    final token = await AuthService.getToken();

    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/addprogress/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'tanggal': tanggal,
          'proses': proses,
          'aktivitas': aktivitas,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['data'] != null) {
          return DetailProgress.fromJson(data['data']);
        } else {
          throw Exception('Data tidak ditemukan dalam respons');
        }
      } else {
        final message = data['message'] ?? 'Gagal menambahkan progres';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  static Future<List<DetailProgress>> getProgress(int mouId) async {
    final token = await AuthService.getToken();

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/mou/$mouId/progress'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List data = jsonData['data'];
      return data.map((e) => DetailProgress.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data progress');
    }
  }
}
