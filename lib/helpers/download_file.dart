// import 'package:sikermatsu/services/auth_service.dart';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:typed_data';
// import 'dart:html' as html;
// import 'dart:io' as io;
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

// Future<void> downloadFile(String fileUrl, String filename) async {
//   try {
//     final token = await AuthService.getToken();
//     final dio = Dio();
//     final response = await dio.get<List<int>>(
//       fileUrl,
//       options: Options(
//         responseType: ResponseType.bytes,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': _getMimeType(filename),
//         },
//       ),
//     );

//     if (response.statusCode == 200) {
//       final bytes = Uint8List.fromList(response.data!);

//       if (kIsWeb) {
//         // WEB: download via <a> tag
//         final blob = html.Blob([bytes]);
//         final url = html.Url.createObjectUrlFromBlob(blob);
//         final anchor =
//             html.AnchorElement(href: url)
//               ..setAttribute('download', filename)
//               ..click();
//         html.Url.revokeObjectUrl(url);
//         print("File berhasil diunduh (web)");
//       } else {
//         //MOBILE / DESKTOP
//         if (io.Platform.isAndroid || io.Platform.isIOS) {
//           final status = await Permission.storage.request();
//           if (!status.isGranted) {
//             throw Exception("Izin akses penyimpanan ditolak.");
//           }
//         }

//         final dir = await getApplicationDocumentsDirectory();
//         final savePath = '${dir.path}/$filename';

//         final file = io.File(savePath);
//         await file.writeAsBytes(bytes);

//         print("File berhasil disimpan di: $savePath");
//       }
//     } else {
//       print("Gagal download. Status: ${response.statusCode}");
//     }
//   } catch (e) {
//     print("Terjadi kesalahan saat mengunduh: $e");
//   }
// }

// // Fungsi bantu: menentukan header mime type berdasarkan ekstensi file
// String _getMimeType(String filename) {
//   final ext = filename.split('.').last.toLowerCase();
//   switch (ext) {
//     case 'pdf':
//       return 'application/pdf';
//     case 'doc':
//       return 'application/msword';
//     case 'docx':
//       return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
//     case 'jpg':
//     case 'jpeg':
//       return 'image/jpeg';
//     case 'png':
//       return 'image/png';
//     default:
//       return 'application/octet-stream';
//   }
// }

// String getFolderFromType(String type) {
//   switch (type.toLowerCase()) {
//     case 'mou':
//       return 'mou_files';
//     case 'pks':
//       return 'pks_files';
//     case 'pkl':
//       return 'pkl_files';
//     default:
//       throw Exception('Tipe file tidak valid: $type');
//   }
// }
// import 'package:dio/dio.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:open_file/open_file.dart';
// import 'dart:io';

// Future<void> downloadFile(String url, String fileName) async {
//   try {
//     final dio = Dio();
//     final dir = await getApplicationDocumentsDirectory();
//     final filePath = '${dir.path}/$fileName';

//     await dio.download(
//       url,
//       filePath,
//       onReceiveProgress: (received, total) {
//         if (total != -1) {
//           print('Downloading: ${(received / total * 100).toStringAsFixed(0)}%');
//         }
//       },
//     );

//     print('File saved to $filePath');
//     await OpenFile.open(filePath);
//   } catch (e) {
//     print('Download gagal: $e');
//   }
// }
import 'dart:io' as io;
import 'dart:html' as html; // hanya untuk web
import 'package:flutter/foundation.dart'; // untuk kIsWeb
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import '../services/auth_service.dart';

Future<void> downloadFile(String folder, String filename) async {
  final url = 'http://192.168.100.111:8000/api/download/$filename';
  final token = await AuthService.getToken();

  if (kIsWeb) {
    //  Flutter Web
    final anchor =
        html.AnchorElement(href: url)
          ..setAttribute('download', filename)
          ..click();
    print("Download dimulai di web: $url");
  } else {
    //  Android/iOS/Desktop
    try {
      final dio = Dio();
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/$filename';

      final response = await dio.download(
        url,
        filePath,
        // options: Options(
        //   headers: {if (token != null) 'Authorization': 'Bearer $token'},
        // ),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print(
              "Downloading: ${(received / total * 100).toStringAsFixed(0)}%",
            );
          }
        },
      );

      if (response.statusCode == 200) {
        print("Download selesai. File disimpan di: $filePath");
      } else {
        print("Gagal download: ${response.statusCode}");
      }
    } catch (e) {
      print("Terjadi kesalahan saat download: $e");
    }
  }
}
