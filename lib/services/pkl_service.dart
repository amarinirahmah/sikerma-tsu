import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pkl.dart';
import '../services/auth_service.dart';
import 'package:file_picker/file_picker.dart';

class PklService {
  // static const String baseUrl = 'http://192.168.18.248:8000/api';
  static const String baseUrl = "http://192.168.100.238:8000/api";
  // static const String baseUrl = "https://b7c1-158-140-170-0.ngrok-free.app/api";
  static String? token;
  static String? role;

  // Ambil semua data PKL
  static Future<List<Pkl>> getAllPkl() async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/getpkl'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Pkl.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data PKL');
    }
  }

  // Ambil detail PKL berdasarkan ID
  Future<Pkl> getPklById(String id) async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/getpklid/$id'),
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
  static Future<void> uploadPkl(Pkl pkl, {PlatformFile? file}) async {
    final token = await AuthService.getToken();
    final role = await AuthService.getRole();

    final uri = Uri.parse('$baseUrl/uploadpkl');

    final fields = {
      'nisn': pkl.nisn,
      'nama': pkl.nama,
      'sekolah': pkl.sekolah,
      'gender': pkl.gender.toBackend(),
      'tanggal_mulai': pkl.tanggalMulai.toIso8601String(),
      'tanggal_berakhir': pkl.tanggalBerakhir.toIso8601String(),
      'telpemail': pkl.telpEmail,
      'alamat': pkl.alamat,
      if (pkl.status != null) 'status': statusToBackend(pkl.status),
    }.map((key, value) => MapEntry(key, value.toString()));

    if (file == null) {
      // JSON mode
      final response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(fields),
      );

      if (response.statusCode >= 400) {
        throw Exception('Upload gagal: ${response.body}');
      }
    } else {
      // Multipart mode
      final request =
          http.MultipartRequest('POST', uri)
            ..headers['Authorization'] = 'Bearer $token'
            // ..headers['Accept'] = 'application/json'
            ..headers['Content-Type'] = 'application/json'
            ..fields.addAll(fields);

      if (file.bytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'file_pkl',
            file.bytes!,
            filename: file.name,
          ),
        );
      }

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode >= 400) {
        throw Exception('Upload gagal: $responseBody');
      }
    }
  }

  // Update data PKL
  static Future<void> updatePkl(
    String id,
    Pkl pkl, {
    PlatformFile? file,
  }) async {
    final token = await AuthService.getToken();
    final uri = Uri.parse('$baseUrl/updatepkl/$id');

    final request =
        http.MultipartRequest('POST', uri)
          ..headers['Authorization'] = 'Bearer $token'
          ..headers['Accept'] = 'application/json';

    // Kirim field sesuai validasi backend
    request.fields.addAll({
      '_method': 'PUT',
      'nisn': pkl.nisn,
      'nama': pkl.nama,
      'sekolah': pkl.sekolah,
      'gender': pkl.gender.toBackend(),
      'tanggal_mulai': pkl.tanggalMulai.toIso8601String(),
      'tanggal_berakhir': pkl.tanggalBerakhir.toIso8601String(),
      'telpemail': pkl.telpEmail,
      'alamat': pkl.alamat,
    });

    // Tambahkan status hanya jika tidak null
    if (pkl.status != null) {
      request.fields['status'] = pkl.status!.toBackend();
    }

    // Upload file jika ada
    if (file != null && file.bytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'file_pkl',
          file.bytes!,
          filename: file.name,
        ),
      );
    }

    // Kirim request
    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode >= 400) {
      throw Exception('Gagal memperbarui PKL: $responseBody');
    }
  }

  // Mapping enum ke string backend
  static String statusToBackend(StatusPkl? status) {
    switch (status) {
      case StatusPkl.diproses:
        return 'Diproses';
      case StatusPkl.disetujui:
        return 'Disetujui';
      case StatusPkl.ditolak:
        return 'Ditolak';
      default:
        return '';
    }
  }

  // Hapus data PKL
  static Future<void> deletePkl(String id) async {
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

  Future<Pkl> updateStatus(String id, StatusPkl status) async {
    final token = await AuthService.getToken();
    final url = Uri.parse('$baseUrl/statupdate/$id');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'status': status.name}),
    );

    if (response.statusCode == 200) {
      return Pkl.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal update status: ${response.reasonPhrase}');
    }
  }

  static Future<List<Pkl>> getPklSaya() async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/pklSaya'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data'];
      return data.map((json) => Pkl.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data PKL Anda');
    }
  }

  static Future<void> uploadPklUser(Pkl pkl, {PlatformFile? file}) async {
    final token = await AuthService.getToken();

    final uri = Uri.parse('$baseUrl/useruploadpkl');

    final fields = {
      'nisn': pkl.nisn,
      'nama': pkl.nama,
      'sekolah': pkl.sekolah,
      'gender': pkl.gender.toBackend(),
      'tanggal_mulai': pkl.tanggalMulai.toIso8601String(),
      'tanggal_berakhir': pkl.tanggalBerakhir.toIso8601String(),
      'telpemail': pkl.telpEmail,
      'alamat': pkl.alamat,
    }.map((key, value) => MapEntry(key, value.toString()));

    final request =
        http.MultipartRequest('POST', uri)
          ..headers['Authorization'] = 'Bearer $token'
          ..fields.addAll(fields);

    if (file != null && file.bytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'file_pkl',
          file.bytes!,
          filename: file.name,
        ),
      );
    }

    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode == 403 ||
        streamedResponse.statusCode == 409) {
      final decoded = jsonDecode(responseBody);
      throw Exception(decoded['message'] ?? 'Pengajuan gagal');
    } else if (streamedResponse.statusCode >= 400) {
      throw Exception('Upload gagal: $responseBody');
    }
  }

  Future<Pkl> getPklSayaById(String id) async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/pklSaya/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Pkl.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal mengambil detail PKL Anda');
    }
  }
}
