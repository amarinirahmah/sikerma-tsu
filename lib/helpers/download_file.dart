import 'dart:html' as html;
import 'package:http/http.dart' as http;

Future<void> downloadFile(String url, String fileName, String token) async {
  final response = await http.get(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    final bytes = response.bodyBytes;
    final blob = html.Blob([bytes]);
    final objectUrl = html.Url.createObjectUrlFromBlob(blob);

    // Cek ekstensi di fileName, kalau gak ada coba dari URL, jika tetap tidak ada, pakai default pdf
    String? ext = _extractExtension(fileName);
    if (ext == null) {
      ext = _extractExtension(url) ?? 'pdf';
      fileName = '$fileName.$ext';
    }

    final anchor =
        html.AnchorElement(href: objectUrl)
          ..setAttribute('download', fileName)
          ..click();

    html.Url.revokeObjectUrl(objectUrl);
  } else {
    throw Exception('Download gagal: ${response.statusCode}');
  }
}

String? _extractExtension(String path) {
  final dotIndex = path.lastIndexOf('.');
  if (dotIndex != -1 && dotIndex + 1 < path.length) {
    return path.substring(dotIndex + 1).toLowerCase();
  }
  return null;
}

// import 'dart:html' as html;
// import 'dart:typed_data';
// import 'package:http/http.dart' as http;

// Future<void> downloadFile(String url, String fileName, String token) async {
//   final response = await http.get(
//     Uri.parse(url),
//     headers: {'Authorization': 'Bearer $token'},
//   );

//   if (response.statusCode == 200) {
//     final bytes = response.bodyBytes;
//     final blob = html.Blob([bytes]);
//     final url = html.Url.createObjectUrlFromBlob(blob);

//     final extension =
//         _extractExtension(url) ?? _extractExtension(fileName) ?? 'pdf';

//     final anchor =
//         html.AnchorElement(href: url)
//           ..setAttribute('download', '$fileName.$extension')
//           ..click();

//     html.Url.revokeObjectUrl(url);
//   } else {
//     throw Exception('Download gagal: ${response.statusCode}');
//   }
// }

// String? _extractExtension(String path) {
//   final dotIndex = path.lastIndexOf('.');
//   if (dotIndex != -1 && dotIndex + 1 < path.length) {
//     return path.substring(dotIndex + 1).toLowerCase();
//   }
//   return null;
// }
