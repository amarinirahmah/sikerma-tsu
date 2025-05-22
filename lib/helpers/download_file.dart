import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

Future<void> downloadFile(String url, String fileName) async {
  try {
    final dio = Dio();
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$fileName';

    await dio.download(
      url,
      filePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          print('Downloading: ${(received / total * 100).toStringAsFixed(0)}%');
        }
      },
    );

    print('File saved to $filePath');
    await OpenFile.open(filePath);
  } catch (e) {
    print('Download gagal: $e');
  }
}
