import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/app_state.dart';

class AuthService {
  static const baseUrl = "http://192.168.100.111:8000/api";
  // static const baseUrl = "https://b7c1-158-140-170-0.ngrok-free.app/api";

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

  // Fetch data user dari API, throw exception jika error
  // static Future<Map<String, dynamic>> fetchUserFromAPI() async {
  //   final token = await getToken();
  //   if (token == null) throw Exception("Token tidak ditemukan. Silakan login.");

  //   final response = await http.get(
  //     Uri.parse('$baseUrl/users'),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json',
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     if (data is List && data.isNotEmpty) {
  //       return data.first;
  //     } else if (data is Map<String, dynamic>) {
  //       return data;
  //     } else {
  //       throw Exception("Data user tidak valid.");
  //     }
  //   } else {
  //     throw Exception("Gagal mengambil data user: ${response.statusCode}");
  //   }
  // }

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
      Uri.parse('${AuthService.baseUrl}/registerbyadmin'),
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
      Uri.parse('${AuthService.baseUrl}/registeruser'),
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
      Uri.parse('$baseUrl/users'),
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

  // UPDATE USER
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
      Uri.parse('$baseUrl/updateuser/$id'),
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

  // static Future<void> updateUser({
  //   required int id,
  //   required String name,
  //   required String email,
  //   required String role,
  // }) async {
  //   final response = await http.put(
  //     Uri.parse('$baseUrl/users/$id'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'name': name, 'email': email, 'role': role}),
  //   );

  //   if (response.statusCode != 200) {
  //     final data = jsonDecode(response.body);
  //     throw Exception(data['message'] ?? 'Gagal mengedit user');
  //   }
  // }

  // DELETE USER
  static Future<void> deleteUser(id) async {
    final token = await AuthService.getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/deleteuser/$id'),
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
