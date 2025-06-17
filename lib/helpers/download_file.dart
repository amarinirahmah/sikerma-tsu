import 'dart:io' as io;
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import '../services/auth_service.dart';
import '../constants/api_constants.dart';

Future<void> downloadFile(String folder, String filename) async {
  // final url = 'http://192.168.100.238:8000/api/download/$filename';
  final url = '${ApiConstants.baseUrl}/download/$filename';
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
