import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pkl.dart';
import '../services/auth_service.dart';

class PklService {
  static const String baseUrl = 'http://192.168.100.238:8000/api';
  static String? token;
  static String? role;

  // // Ambil token dari SharedPreferences untuk otorisasi
  // Future<String> _getToken() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('token') ?? '';
  // }

  // // Header JSON standar dengan token
  // Future<Map<String, String>> _jsonHeaders() async => {
  //   'Content-Type': 'application/json',
  //   'Authorization': 'Bearer ${await _getToken()}',
  // };

  // Ambil semua data PKL
  static Future<List<Pkl>> getAllPkl() async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/getpkl'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Pkl.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data PKL');
    }
  }

  // Ambil detail PKL berdasarkan ID
  static Future<Pkl> getPklById(String id) async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/getpkl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Pkl.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Data PKL tidak ditemukan');
    }
  }

  // Upload data PKL baru (dengan/ tanpa file)
  Future<void> uploadPkl(Pkl pkl, {File? file}) async {
    final token = await AuthService.getToken();
    final uri = Uri.parse('$baseUrl/uploadpkl');

    if (file == null) {
      // Mode JSON (tanpa file)
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(pkl.toJson()),
      );

      if (response.statusCode >= 400) {
        throw Exception('Upload gagal: ${response.body}');
      }
    } else {
      // Mode Multipart (dengan file)
      final request =
          http.MultipartRequest('POST', uri)
            ..headers['Authorization'] = 'Bearer $token'
            ..fields.addAll(
              pkl.toJson().map((key, value) => MapEntry(key, value.toString())),
            )
            ..files.add(
              await http.MultipartFile.fromPath(
                'file_pkl',
                file.path,
                filename: basename(file.path),
              ),
            );

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode >= 400) {
        throw Exception('Upload PKL gagal (dengan file): ${response.body}');
      }
    }
  }

  // Update data PKL
  Future<void> updatePkl(String id, Pkl pkl, {File? file}) async {
    final token = await AuthService.getToken();
    final uri = Uri.parse('$baseUrl/updatepkl/$id');

    if (file != null) {
      // Mode multipart update dengan file
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      request.fields.addAll(
        pkl.toJson().map((key, value) => MapEntry(key, value.toString())),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'file_pkl',
          file.path,
          filename: basename(file.path),
        ),
      );

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Gagal memperbarui PKL: ${response.body}');
      }
    } else {
      // Mode JSON (tanpa file)
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(pkl.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal memperbarui PKL: ${response.body}');
      }
    }
  }

  // Hapus data PKL
  Future<void> deletePkl(String id) async {
    final token = await AuthService.getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/deletepkl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus data PKL');
    }
  }
}
