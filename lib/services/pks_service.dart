import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pks.dart';
import '../services/auth_service.dart';

class PksService {
  static const String baseUrl = 'http://192.168.100.238:8000/api';
  static String? token;
  static String? role;

  //list pks
  static Future<List<Pks>> getAllPks() async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/getpks'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
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
      Uri.parse('$baseUrl/getpks/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Pks.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('PKS tidak ditemukan');
    }
  }

  Future<void> uploadPks(Pks pks, {File? file}) async {
    final token = await AuthService.getToken();
    final uri = Uri.parse('$baseUrl/uploadpks');

    if (file == null) {
      // JSON mode
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'nomormou': pks.nomorMou,
          'nomorpks': pks.nomorPks,
          'judul': pks.judul,
          'tanggal_mulai': pks.tanggalMulai.toIso8601String(),
          'tanggal_berakhir': pks.tanggalBerakhir.toIso8601String(),
          'namaunit': pks.namaUnit,
          'tujuan': pks.tujuan,
          'keterangan': pks.keterangan.name,
          if (pks.status != null) 'status': pks.status!.name,
        }),
      );

      if (response.statusCode >= 400) {
        throw Exception('Upload gagal: ${response.body}');
      }
    } else {
      // Multipart mode
      final request =
          http.MultipartRequest('POST', uri)
            ..headers['Authorization'] = 'Bearer $token'
            ..fields['nomormou'] = pks.nomorMou
            ..fields['nomorpks'] = pks.nomorPks
            ..fields['judul'] = pks.judul
            ..fields['tanggal_mulai'] = pks.tanggalMulai.toIso8601String()
            ..fields['tanggal_berakhir'] = pks.tanggalBerakhir.toIso8601String()
            ..fields['namaunit'] = pks.namaUnit
            ..fields['tujuan'] = pks.tujuan
            ..fields['keterangan'] = pks.keterangan.name;

      if (pks.status != null) {
        request.fields['status'] = pks.status!.name;
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          'file_pks',
          file.path,
          filename: basename(file.path),
        ),
      );

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode >= 400) {
        throw Exception('Upload gagal (dengan file): ${response.body}');
      }
    }
  }

  //edit pks
  Future<void> updatePks(String id, Pks pks, {File? file}) async {
    final token = await AuthService.getToken();
    final uri = Uri.parse('$baseUrl/updatepks/$id');

    if (file != null) {
      // Multipart dengan file
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['nomormou'] = pks.nomorMou;
      request.fields['nomorpks'] = pks.nomorPks;
      request.fields['judul'] = pks.judul;
      request.fields['tanggal_mulai'] = pks.tanggalMulai.toIso8601String();
      request.fields['tanggal_berakhir'] =
          pks.tanggalBerakhir.toIso8601String();
      request.fields['namaunit'] = pks.namaUnit;
      request.fields['tujuan'] = pks.tujuan;
      if (pks.status != null) {
        request.fields['status'] = statusToBackend(pks.status);
      }
      request.fields['keterangan'] = keteranganToBackend(pks.keterangan);

      request.files.add(
        await http.MultipartFile.fromPath('file_pks', file.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Gagal memperbarui PKS: ${response.body}');
      }
    } else {
      // Update tanpa file
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = {
        'nomormou': pks.nomorMou,
        'nomorpks': pks.nomorPks,
        'judul': pks.judul,
        'tanggal_mulai': pks.tanggalMulai.toIso8601String(),
        'tanggal_berakhir': pks.tanggalBerakhir.toIso8601String(),
        'namaunit': pks.namaUnit,
        'tujuan': pks.tujuan,
        'status': pks.status != null ? statusToBackend(pks.status) : null,
        'keterangan': keteranganToBackend(pks.keterangan),
      }..removeWhere((key, value) => value == null);

      final response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal memperbarui PKS: ${response.body}');
      }
    }
  }

  // Mapping enum ke string backend
  String statusToBackend(StatusPks? status) {
    switch (status) {
      case StatusPks.aktif:
        return 'Aktif';
      case StatusPks.nonaktif:
        return 'Nonaktif';
      default:
        return '';
    }
  }

  String keteranganToBackend(KeteranganPks keterangan) {
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
  Future<void> deletePks(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/deletepks/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus PKS');
    }
  }
}
