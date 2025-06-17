import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notifikasi.dart';
import '../services/auth_service.dart';
import '../constants/api_constants.dart';

class NotifService {
  // static const String baseUrl = "http://192.168.100.238:8000/api";

  Future<List<Notifikasi>> getAllNotif({String? type, String? tanggal}) async {
    final token = await AuthService.getToken();

    final uri = Uri.parse('${ApiConstants.baseUrl}/notifikasi').replace(
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
}
