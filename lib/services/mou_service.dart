import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mou.dart';
import '../services/auth_service.dart';
import 'package:file_picker/file_picker.dart';

class MouService {
  static const String baseUrl = 'http://192.168.18.248:8000/api';
  static String? token;
  static String? role;
  static  File? selectedFile;

  // Future<String> _getToken() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('token') ?? '';
  // }

  // Future<Map<String, String>> _jsonHeaders() async => {
  //   'Content-Type': 'application/json',
  //   'Authorization': 'Bearer ${await _getToken()}',
  // };

  // //list mou
  // static Future<List<Mou>> getAllMou() async {
  //   final token = await AuthService.getToken();
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/getmou'),
  //     headers: {   'Accept': 'application/json',
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',},
  //   );

  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = jsonDecode(response.body);
  //     return data.map((json) => Mou.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Gagal mengambil data MoU');
  //   }
  // }

//   static Future<List<Mou>> getAllMou() async {
//   final token = await AuthService.getToken();
  
//   Map<String, String> headers = {
//     'Accept': 'application/json',
//     'Content-Type': 'application/json',
//   };

//   if (token != null && token.isNotEmpty) {
//     headers['Authorization'] = 'Bearer $token';
//   }

//   final response = await http.get(
//     Uri.parse('$baseUrl/getmou'),
//     headers: headers,
//   );

//   if (response.statusCode == 200) {
//     final List<dynamic> data = jsonDecode(response.body);
//     return data.map((json) => Mou.fromJson(json)).toList();
//   } else {
//     throw Exception('Gagal mengambil data MoU');
//   }
// }

static Future<List<Mou>> getAllMou() async {
  final token = await AuthService.getToken();

  final headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  // Tambahkan Authorization hanya jika token ada
  if (token != null && token.isNotEmpty) {
    headers['Authorization'] = 'Bearer $token';
  }

  final response = await http.get(
    Uri.parse('$baseUrl/getmou'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Mou.fromJson(json)).toList();
  } else {
    throw Exception('Gagal mengambil data MoU');
  }
}

static Future<Mou> getMouById(String id) async {
  final token = await AuthService.getToken();

  final headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  // Tambahkan Authorization hanya jika token ada
  if (token != null && token.isNotEmpty) {
    headers['Authorization'] = 'Bearer $token';
  }

  final response = await http.get(
    Uri.parse('$baseUrl/getmou/$id'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    return Mou.fromJson(jsonDecode(response.body));
  } else {
   throw Exception('MoU tidak ditemukan');
  }
}

  // //detail mou
  // static Future<Mou> getMouById(String id) async {
  //   final token = await AuthService.getToken();
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/getmou/$id'),
  //     headers: {
  //       'Accept': 'application/json',
  //        'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     return Mou.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('MoU tidak ditemukan');
  //   }
  // }

static Future<void> uploadMou(Mou mou, {PlatformFile? file}) async {
  final token = await AuthService.getToken();
  final uri = Uri.parse('$baseUrl/uploadmou');

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
    final request = http.MultipartRequest('POST', uri)
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


//   Future<void> uploadMou(Mou mou, {File? file}) async {
//     final token = await AuthService.getToken();
//     final uri = Uri.parse('$baseUrl/uploadmou');

//     if (file == null) {
//       // JSON mode
//       final response = await http.post(
//         uri,
//         headers: {
//           'Accept': 'application/json',
//            'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({
//           'nomormou': mou.nomorMou,
//            'nomormou2': mou.nomorMou2,
//           'nama': mou.nama,
//           'judul': mou.judul,
//           'tanggal_mulai': mou.tanggalMulai.toIso8601String(),
//           'tanggal_berakhir': mou.tanggalBerakhir.toIso8601String(),
//           'ruanglingkup': mou.ruangLingkup,
//           'nama1': mou.pihak1.nama,
//             'jabatan1': mou.pihak1.jabatan,
//               'alamat1': mou.pihak1.alamat,
//           'nama2': mou.pihak2.nama,
//            'jabatan2': mou.pihak2.jabatan,
//               'alamat2': mou.pihak2.alamat,
//       //        'pihak1': mou.pihak1.toJson(),
//       // 'pihak2': mou.pihak2.toJson(),
//           'keterangan': keteranganToBackend(mou.keterangan),  
//           if (mou.status != null) 'status': statusToBackend(mou.status),
//         }),
//       );

//       if (response.statusCode >= 400) {
//         throw Exception('Upload gagal: ${response.body}');
//       }
//     } else {
//       // Multipart mode
//       final uri = Uri.parse('$baseUrl/uploadmou');
//       final request =
//           http.MultipartRequest('POST', uri)
//              ..headers['Authorization'] = 'Bearer $token'
//             ..fields['nomormou'] = mou.nomorMou
//               ..fields['nomormou2'] = mou.nomorMou2
//             ..fields['nama'] = mou.nama
//             ..fields['judul'] = mou.judul
//             ..fields['tanggal_mulai'] = mou.tanggalMulai.toIso8601String()
//             ..fields['tanggal_berakhir'] = mou.tanggalBerakhir.toIso8601String()
//             ..fields['ruanglingkup'] = mou.ruangLingkup
//             ..fields['nama1'] = mou.pihak1.nama
// ..fields['jabatan1'] = mou.pihak1.jabatan
// ..fields['alamat1'] = mou.pihak1.alamat
// ..fields['nama2'] = mou.pihak2.nama
// ..fields['jabatan2'] = mou.pihak2.jabatan
// ..fields['alamat2'] = mou.pihak2.alamat

//       //       ..fields['pihak1'] = jsonEncode(mou.pihak1.toJson())
//       // ..fields['pihak2'] = jsonEncode(mou.pihak2.toJson())
//             ..fields['keterangan'] = keteranganToBackend(mou.keterangan);

//       if (mou.status != null) {
//         request.fields['status'] = statusToBackend(mou.status);
//       }

//       var fileStream = http.ByteStream(selectedFile!.openRead());
//       var fileLength = await selectedFile!.length();
//       var multipartFile = http.MultipartFile('file_mou', fileStream, fileLength, filename: basename(selectedFile!.path),);

// request.files.add(multipartFile);
// var response = await request.send();

// if (response.statusCode == 200) {
//   print('Upload berhasil!');
//   var responseBody = await response.stream.bytesToString();
//   print(responseBody);
// } else {
//   print('Upload gagal dengan status: ${response.statusCode}');
// }

//       // request.files.add(
//       //   await http.MultipartFile.fromPath(
//       //     'file_mou',
//       //     file.path,
//       //     filename: basename(file.path),
//       //   ),
//       // );

//       // final response = await http.Response.fromStream(await request.send());

//       // if (response.statusCode >= 400) {
//       //   throw Exception('Upload gagal (dengan file): ${response.body}');
//       // }
//     }
//   }

  //edit mou
//   Future<void> updateMou(String id, Mou mou, {PlatformFile? file}) async {
//   final token = await AuthService.getToken();
//   final uri = Uri.parse('$baseUrl/updatemou/$id');

//    print('Token: $token');
//   print('URL: $uri');

//   final fields = {
//     'nomormou': mou.nomorMou,
//     'nomormou2': mou.nomorMou2,
//     'nama': mou.nama,
//     'judul': mou.judul,
//     'tanggal_mulai': mou.tanggalMulai.toIso8601String(),
//     'tanggal_berakhir': mou.tanggalBerakhir.toIso8601String(),
//     'ruanglingkup': mou.ruangLingkup,
//     'nama1': mou.pihak1.nama,
//     'jabatan1': mou.pihak1.jabatan,
//     'alamat1': mou.pihak1.alamat,
//     'nama2': mou.pihak2.nama,
//     'jabatan2': mou.pihak2.jabatan,
//     'alamat2': mou.pihak2.alamat,
//     'keterangan': keteranganToBackend(mou.keterangan),
//     if (mou.status != null) 'status': statusToBackend(mou.status),
//     '_method': 'PUT', // method override untuk Laravel
//   };

//   final request = http.MultipartRequest('POST', uri)
  
//     ..headers['Authorization'] = 'Bearer $token'
//     ..fields.addAll(fields);

//   if (file != null && file.bytes != null) {
//     request.files.add(
//       http.MultipartFile.fromBytes(
//         'file_mou',
//         file.bytes!,
//         filename: file.name,
//       ),
//     );
//   }

//   final streamedResponse = await request.send();
//   final response = await http.Response.fromStream(streamedResponse);

//    print('Response status: ${response.statusCode}');
//   print('Response body: ${response.body}');

//   if (response.statusCode >= 400) {
//     throw Exception('Gagal memperbarui MoU: ${response.body}');
//   }
// }

static Future<void> updateMou(String id, Mou mou, {PlatformFile? file}) async {
  final token = await AuthService.getToken();
  final uri = Uri.parse('$baseUrl/updatemou/$id');

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
    '_method': 'PUT', // Laravel membutuhkan override ini saat pakai Multipart
  };

   // Debug print fields untuk cek data sebelum dikirim
  print('Fields yang akan dikirim ke backend:');
  fields.forEach((key, value) {
    print('$key: $value (${value.runtimeType})');
  });

  final request = http.MultipartRequest('POST', uri)
    ..headers['Authorization'] = 'Bearer $token'
    ..headers['Accept'] = 'application/json'
        ..headers['Content-Type'] = 'application/json'
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

 static Future<void> deleteMou(String id) async {
    final token = await AuthService.getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/deletemou/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus MoU');
    }
  }
}
