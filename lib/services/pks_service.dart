import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pks.dart';
import '../services/auth_service.dart';
import 'package:file_picker/file_picker.dart';
import '../constants/api_constants.dart';

class PksService {
  // static const String baseUrl = "http://192.168.100.238:8000/api";
  static String? token;
  static String? role;

  //list pks
  static Future<List<Pks>> getAllPks() async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/getpks'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Pks.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data PKS');
    }
  }

  //detail pks
  Future<Pks> getPksById(String id) async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/getpksid/$id'),
      headers: {
        // 'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Pks.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('PKS tidak ditemukan');
    }
  }

  static Future<void> uploadPks(Pks pks, {PlatformFile? file}) async {
    final token = await AuthService.getToken();
    final uri = Uri.parse('${ApiConstants.baseUrl}/uploadpks');

    final fields = {
      'nomormou': pks.nomorMou,
      'nomorpks': pks.nomorPks,
      'judul': pks.judul,
      'tanggal_mulai': pks.tanggalMulai.toIso8601String(),
      'tanggal_berakhir': pks.tanggalBerakhir.toIso8601String(),
      'namaunit': pks.namaUnit,
      'ruanglingkup': pks.ruangLingkup,
      'keterangan': keteranganToBackend(pks.keterangan),
      if (pks.status != null) 'status': statusToBackend(pks.status),
    };

    if (file == null) {
      // JSON mode
      final response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
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
            ..headers['Content-Type'] = 'application/json'
            ..fields.addAll(fields);

      if (file.bytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'file_pks',
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

  //edit pks
  static Future<void> updatePks(
    String id,
    Pks pks, {
    PlatformFile? file,
  }) async {
    final token = await AuthService.getToken();
    final uri = Uri.parse('${ApiConstants.baseUrl}/updatepks/$id');

    final fields = {
      'nomorpks': pks.nomorPks,
      'nomormou': pks.nomorMou,
      'judul': pks.judul,
      'tanggal_mulai': pks.tanggalMulai.toIso8601String(),
      'tanggal_berakhir': pks.tanggalBerakhir.toIso8601String(),
      'namaunit': pks.namaUnit,
      'ruanglingkup': pks.ruangLingkup,
      'keterangan': keteranganToBackend(pks.keterangan),
      if (pks.status != null) 'status': statusToBackend(pks.status),
      '_method': 'PUT',
    };

    final request =
        http.MultipartRequest('POST', uri)
          ..headers['Authorization'] = 'Bearer $token'
          ..headers['Accept'] = 'application/json'
          ..fields.addAll(fields);

    if (file != null && file.bytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'file_pks',
          file.bytes!,
          filename: file.name,
        ),
      );
    }

    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode >= 400) {
      throw Exception('Gagal memperbarui PKS: $responseBody');
    }
  }

  // Mapping enum ke string backend
  static String statusToBackend(StatusPks? status) {
    switch (status) {
      case StatusPks.aktif:
        return 'Aktif';
      case StatusPks.nonaktif:
        return 'Tidak Aktif';
      default:
        return '';
    }
  }

  static String keteranganToBackend(KeteranganPks keterangan) {
    switch (keterangan) {
      case KeteranganPks.diajukan:
        return 'Diajukan';
      case KeteranganPks.disetujui:
        return 'Disetujui';
      case KeteranganPks.dibatalkan:
        return 'Dibatalkan';
    }
  }

  //delete
  static Future<void> deletePks(String id) async {
    final token = await AuthService.getToken();
    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/deletepks/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus PKS');
    }
  }

  Future<Pks> updateKeterangan(String id, KeteranganPks keterangan) async {
    final token = await AuthService.getToken();
    final url = Uri.parse('${ApiConstants.baseUrl}/ketupdate/$id');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'keterangan': keterangan.name}),
    );

    if (response.statusCode == 200) {
      return Pks.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal update keterangan PKS: ${response.reasonPhrase}');
    }
  }
}
