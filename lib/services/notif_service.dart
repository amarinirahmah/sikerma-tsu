import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notifikasi.dart';
import '../services/auth_service.dart'; // untuk token auth

class NotifService {
  // static const String baseUrl = 'http://192.168.18.248:8000/api';
  static const String baseUrl = "http://192.168.18.248:8000/api";

  Future<List<Notifikasi>> getAllNotif({String? type, String? tanggal}) async {
    final token = await AuthService.getToken();

    // Bangun URL dengan query jika tersedia
    final uri = Uri.parse('$baseUrl/notifikasi').replace(
      queryParameters: {
        if (type != null) 'type': type,
        if (tanggal != null) 'tanggal': tanggal,
      },
    );

    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      return data.map((json) => Notifikasi.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil notifikasi: ${response.body}');
    }
  }

  // Future<void> deleteNotif(int id) async {
  //   final token = await AuthService.getToken();

  //   final response = await http.delete(
  //     Uri.parse('$baseUrl/notifikasi/$id'),
  //     headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
  //   );

  //   if (response.statusCode != 200) {
  //     throw Exception('Gagal menghapus notifikasi: ${response.body}');
  //   }
  // }
}
