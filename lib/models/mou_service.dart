import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mou.dart';

class MouService {
  final String baseUrl = 'http://192.168.100.238:8000/api';

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<Map<String, String>> _jsonHeaders() async => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${await _getToken()}',
  };

  //list mou
  Future<List<Mou>> getAllMou() async {
    final response = await http.get(
      Uri.parse('$baseUrl/getmou'),
      headers: await _jsonHeaders(),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Mou.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data MoU');
    }
  }

  //detail mou
  Future<Mou> getMouById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/getmou/$id'),
      headers: await _jsonHeaders(),
    );

    if (response.statusCode == 200) {
      return Mou.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('MoU tidak ditemukan');
    }
  }

  Future<void> uploadMou(Mou mou, {File? file}) async {
    final token = await _getToken();
    final uri = Uri.parse('$baseUrl/uploadmou');

    if (file == null) {
      // JSON mode
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'nomormou': mou.nomormou,
          'nama': mou.nama,
          'judul': mou.judul,
          'tanggal_mulai': mou.tanggalMulai.toIso8601String(),
          'tanggal_berakhir': mou.tanggalBerakhir.toIso8601String(),
          'tujuan': mou.tujuan,
          'keterangan': mou.keterangan.name,
          if (mou.status != null) 'status': mou.status!.name,
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
            ..fields['nomormou'] = mou.nomormou
            ..fields['nama'] = mou.nama
            ..fields['judul'] = mou.judul
            ..fields['tanggal_mulai'] = mou.tanggalMulai.toIso8601String()
            ..fields['tanggal_berakhir'] = mou.tanggalBerakhir.toIso8601String()
            ..fields['tujuan'] = mou.tujuan
            ..fields['keterangan'] = mou.keterangan.name;

      if (mou.status != null) {
        request.fields['status'] = mou.status!.name;
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          'file_mou',
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

  //edit mou
  Future<void> updateMou(String id, Mou mou, {File? file}) async {
    final token = await _getToken();
    final uri = Uri.parse('$baseUrl/updatemou/$id');

    if (file != null) {
      // Multipart dengan file
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['nonormou'] = mou.nomormou;
      request.fields['nama'] = mou.nama;
      request.fields['judul'] = mou.judul;
      request.fields['tanggal_mulai'] = mou.tanggalMulai.toIso8601String();
      request.fields['tanggal_berakhir'] =
          mou.tanggalBerakhir.toIso8601String();
      request.fields['tujuan'] = mou.tujuan;
      if (mou.status != null) {
        request.fields['status'] = statusToBackend(mou.status);
      }
      request.fields['keterangan'] = keteranganToBackend(mou.keterangan);

      request.files.add(
        await http.MultipartFile.fromPath('file_mou', file.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Gagal memperbarui MoU: ${response.body}');
      }
    } else {
      // Update tanpa file
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = {
        'nomormou': mou.nomormou,
        'nama': mou.nama,
        'judul': mou.judul,
        'tanggal_mulai': mou.tanggalMulai.toIso8601String(),
        'tanggal_berakhir': mou.tanggalBerakhir.toIso8601String(),
        'tujuan': mou.tujuan,
        'status': mou.status != null ? statusToBackend(mou.status) : null,
        'keterangan': keteranganToBackend(mou.keterangan),
      }..removeWhere((key, value) => value == null);

      final response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal memperbarui MoU: ${response.body}');
      }
    }
  }

  // Mapping enum ke string backend (sesuai backendmu)
  String statusToBackend(StatusMou? status) {
    switch (status) {
      case StatusMou.aktif:
        return 'Aktif';
      case StatusMou.nonaktif:
        return 'Nonaktif';
      default:
        return '';
    }
  }

  String keteranganToBackend(KeteranganMou keterangan) {
    switch (keterangan) {
      case KeteranganMou.diajukan:
        return 'Diajukan';
      case KeteranganMou.disetujui:
        return 'Disetujui';
      case KeteranganMou.dibatalkan:
        return 'Dibatalkan';
    }
  }

  // Future<void> updateMou(String id, Mou mou, {File? file}) async {
  //   final token = await _getToken();
  //   final uri = Uri.parse('$baseUrl/updatemou/$id');

  //   if (file != null) {
  //     // Kalau ada file, pakai MultipartRequest
  //     final request = http.MultipartRequest(
  //       'POST',
  //       uri,
  //     ); // Ganti ke 'PUT' jika backend support
  //     request.headers['Authorization'] = 'Bearer $token';

  //     // Fields
  //     request.fields['nomormou'] = mou.nomormou;
  //     request.fields['nama'] = mou.nama;
  //     request.fields['judul'] = mou.judul;
  //     request.fields['tanggal_mulai'] = mou.tanggalMulai.toIso8601String();
  //     request.fields['tanggal_berakhir'] =
  //         mou.tanggalBerakhir.toIso8601String();
  //     request.fields['tujuan'] = mou.tujuan;
  //     if (mou.status != null) {
  //       request.fields['status'] = mou.status!.name;
  //     }
  //     request.fields['keterangan'] = mou.keterangan.name;

  //     // File
  //     request.files.add(
  //       await http.MultipartFile.fromPath('file_mou', file.path),
  //     );

  //     final streamedResponse = await request.send();
  //     final response = await http.Response.fromStream(streamedResponse);

  //     if (response.statusCode != 200 && response.statusCode != 201) {
  //       throw Exception('Gagal memperbarui MoU: ${response.body}');
  //     }
  //   } else {
  //     // Kalau tidak ada file, cukup kirim JSON biasa
  //     final headers = {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     };

  //     final response = await http.put(
  //       uri,
  //       headers: headers,
  //       body: jsonEncode(mou.toJson()),
  //     );

  //     if (response.statusCode != 200) {
  //       throw Exception('Gagal memperbarui MoU: ${response.body}');
  //     }
  //   }
  // }

  Future<void> deleteMou(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/deletemou/$id'),
      headers: await _jsonHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus MoU');
    }
  }
}
