import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'user.dart';

class AuthService {
  static const baseUrl = "http://192.168.1.142:8000/api";
  static String? token;
  static String? role;

  // Login: return role jika berhasil, throw Exception jika gagal
  static Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final user = User.fromJson(data['user']);
      final prefs = await SharedPreferences.getInstance();

      // Simpan token & role ke SharedPreferences
      final token = data['token'] ?? '';
      final role = data['role'] ?? '';

      await prefs.setString('token', token);
      await prefs.setString('role', role);

      return user;
    }
    // return null;
    else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Login gagal');
    }
  }

  // Ambil token dari memori atau SharedPreferences
  static Future<String?> getToken() async {
    if (token != null) return token;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    return token;
  }

  // Ambil role dari memori atau SharedPreferences
  static Future<String?> getRole() async {
    if (role != null) return role;
    final prefs = await SharedPreferences.getInstance();
    role = prefs.getString('role');
    return role;
  }

  // Fetch data user dari API, throw exception jika error
  static Future<Map<String, dynamic>> fetchUserFromAPI() async {
    final token = await getToken();
    if (token == null) throw Exception("Token tidak ditemukan. Silakan login.");

    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List && data.isNotEmpty) {
        return data.first;
      } else if (data is Map<String, dynamic>) {
        return data;
      } else {
        throw Exception("Data user tidak valid.");
      }
    } else {
      throw Exception("Gagal mengambil data user: ${response.statusCode}");
    }
  }

  // Logout: hapus token & role di memori dan SharedPreferences
  static Future<void> logout() async {
    token = null;
    role = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
  }
}
