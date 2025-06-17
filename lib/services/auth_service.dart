import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../core/app_state.dart';
import '../constants/api_constants.dart';

class AuthService {
  // static const baseUrl = "http://192.168.100.238:8000/api";
  static String? token;
  static String? role;

  // Login
  static Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final user = User.fromJson(data['user']);
      final prefs = await SharedPreferences.getInstance();

      // Simpan token & role ke SharedPreferences
      final token = data['token'] ?? '';
      final role = data['user']['role'] ?? '';

      await prefs.setString('token', token);
      await prefs.setString('role', role);

      AppState.loginAs(role, token);
      // await AppState.loginAs(token, role);

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

  // Logout: hapus token & role di memori dan SharedPreferences
  static Future<void> logout() async {
    // token = null;
    // role = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');

    token = null;
    role = null;

    AppState.logout();
  }

  //register user by admin
  static Future<void> registerUserByAdmin(
    String name,
    String email,
    String password,
    String role,
  ) async {
    final token = await AuthService.getToken();
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/registerbyadmin'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      }),
    );

    if (response.statusCode == 200) {
      // print("User berhasil ditambahkan");
      return;
    } else {
      final data = jsonDecode(response.body);
      String message = data['message'] ?? 'Gagal menambahkan user';
      throw Exception(message);
    }
  }

  //register userpkl
  static Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/registeruser'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "role": "userpkl",
      }),
    );

    if (response.statusCode == 200) {
      // print("User berhasil ditambahkan");
      return;
    } else {
      final data = jsonDecode(response.body);
      String message = data['message'] ?? 'Register gagal';
      throw Exception(message);
    }
  }

  //get all user
  static Future<List<User>> getAllUser() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data user');
    }
  }

  // update user
  static Future<void> updateUser({
    required int id,
    required String name,
    required String email,
    required String role,
    required String token,
  }) async {
    final Map<String, dynamic> body = {
      'name': name,
      'email': email,
      'role': role,
    };

    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/updateuser/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Gagal mengupdate user');
    }
  }

  // delete user
  static Future<void> deleteUser(id) async {
    final token = await AuthService.getToken();
    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/deleteuser/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus User');
    }
  }
}
