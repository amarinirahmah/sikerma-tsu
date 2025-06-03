import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sikermatsu/models/detail_progres.dart';
import 'auth_service.dart';

class DetailProgressService {
  static const String baseUrl = "http://192.168.100.6:8000/api";
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
        Uri.parse('$baseUrl/addprogress/$id'),
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
}

// class DetailProgressService {
//   static const String baseUrl = "http://192.168.100.6:8000/api";
//   static String? token;
//   static String? role;

//   static Future<DetailProgress> addProgress({
//     required int id,
//     required String tanggal,
//     required String aktivitas,
//     required String proses,
//   }) async {
//     final token = await AuthService.getToken();
//     final response = await http.post(
//       Uri.parse('$baseUrl/addprogress/$id'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Accept': 'application/json',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'tanggal': tanggal,
//         'proses': proses,
//         'aktivitas': aktivitas,
//       }),
//     );

//     final data = jsonDecode(response.body);

//     if (response.statusCode == 200) {
//       // final data = jsonDecode(response.body);
//       return DetailProgress.fromJson(data['data']);
//     } else {
//       print('Gagal tambah progress: ${response.statusCode} - $data');
//       throw Exception(data['message'] ?? 'Gagal menambahkan progres');
//       // final error = jsonDecode(response.body);
//       // throw Exception(error['message'] ?? 'Gagal menambahkan progres');
//     }
//   }
