import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mou.dart';
import '../services/auth_service.dart';
import 'package:file_picker/file_picker.dart';
import '../constants/api_constants.dart';

class MouService {
  // static const baseUrl = "http://192.168.100.238:8000/api";
  static String? token;
  static String? role;
  static File? selectedFile;

  //list pks
  static Future<List<Mou>> getAllMou() async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/getmou'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Mou.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data MoU');
    }
  }

  //detail pks
  Future<Mou> getMouById(String id) async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/getmouid/$id'),
      headers: {
        // 'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Mou.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('MoU tidak ditemukan');
    }
  }

  static Future<void> uploadMou(Mou mou, {PlatformFile? file}) async {
    final token = await AuthService.getToken();
    final uri = Uri.parse('${ApiConstants.baseUrl}/uploadmou');

    final fields = {
      'nomormou': mou.nomorMou,
      'nomormou2': mou.nomorMou2,
      'nama': mou.nama,
      'judul': mou.judul,
      'tanggal_mulai': mou.tanggalMulai.toIso8601String(),
      'tanggal_berakhir': mou.tanggalBerakhir.toIso8601String(),
      'ruanglingkup': mou.ruangLingkup,
      'nama1': mou.pihak1.nama,
      'jabatan1': mou.pihak1.jabatan,
      'alamat1': mou.pihak1.alamat,
      'nama2': mou.pihak2.nama,
      'jabatan2': mou.pihak2.jabatan,
      'alamat2': mou.pihak2.alamat,
      'keterangan': keteranganToBackend(mou.keterangan),
      if (mou.status != null) 'status': statusToBackend(mou.status),
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
            ..fields.addAll(fields);

      if (file.bytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'file_mou',
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

  static Future<void> updateMou(
    String id,
    Mou mou, {
    PlatformFile? file,
  }) async {
    final token = await AuthService.getToken();
    final uri = Uri.parse('${ApiConstants.baseUrl}/updatemou/$id');

    final fields = {
      'nomormou': mou.nomorMou,
      'nomormou2': mou.nomorMou2,
      'nama': mou.nama,
      'judul': mou.judul,
      'tanggal_mulai': mou.tanggalMulai.toIso8601String(),
      'tanggal_berakhir': mou.tanggalBerakhir.toIso8601String(),
      'ruanglingkup': mou.ruangLingkup,
      'pihak1': jsonEncode({
        'nama': mou.pihak1.nama,
        'jabatan': mou.pihak1.jabatan,
        'alamat': mou.pihak1.alamat,
      }),
      'pihak2': jsonEncode({
        'nama': mou.pihak2.nama,
        'jabatan': mou.pihak2.jabatan,
        'alamat': mou.pihak2.alamat,
      }),

      // 'nama1': mou.pihak1.nama,
      // 'jabatan1': mou.pihak1.jabatan,
      // 'alamat1': mou.pihak1.alamat,
      // 'nama2': mou.pihak2.nama,
      // 'jabatan2': mou.pihak2.jabatan,
      // 'alamat2': mou.pihak2.alamat,
      'keterangan': keteranganToBackend(mou.keterangan),
      if (mou.status != null) 'status': statusToBackend(mou.status),
      '_method': 'PUT',
    };

    final request =
        http.MultipartRequest('POST', uri)
          ..headers['Authorization'] = 'Bearer $token'
          ..headers['Accept'] = 'application/json'
          // ..headers['Content-Type'] = 'application/json'
          ..fields.addAll(fields);

    if (file != null && file.bytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'file_mou',
          file.bytes!,
          filename: file.name,
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode >= 400) {
      throw Exception('Gagal memperbarui MoU: ${response.body}');
    }
  }

  // Mapping enum ke string backend (sesuai backendmu)
  static String statusToBackend(StatusMou? status) {
    switch (status) {
      case StatusMou.aktif:
        return 'Aktif';
      case StatusMou.nonaktif:
        return 'Tidak Aktif';
      default:
        return '';
    }
  }

  static String keteranganToBackend(KeteranganMou keterangan) {
    switch (keterangan) {
      case KeteranganMou.diajukan:
        return 'Diajukan';
      case KeteranganMou.disetujui:
        return 'Disetujui';
      case KeteranganMou.dibatalkan:
        return 'Dibatalkan';
    }
  }

  static Future<void> deleteMou(String id) async {
    final token = await AuthService.getToken();
    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/deletemou/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus MoU');
    }
  }

  Future<Mou> updateKeterangan(String id, KeteranganMou keterangan) async {
    final token = await AuthService.getToken();
    final url = Uri.parse('${ApiConstants.baseUrl}/ketmouupdate/$id');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'keterangan': keterangan.name}),
    );

    if (response.statusCode == 200) {
      return Mou.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal update keterangan: ${response.reasonPhrase}');
    }
  }
}
