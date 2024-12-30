import 'dart:io';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_compressor/pdf_compressor.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class FileCompressor {
  static Future<File> compressFile(File file) async {
    final mimeType = lookupMimeType(file.path) ?? '';
    if (mimeType.contains('image')) {
      final filePath = file.absolute.path;
      final lastIndex = filePath.lastIndexOf(RegExp(r'.jp|.png'));
      final splitted = filePath.substring(0, lastIndex);
      final outPath = "${splitted}_compressed.jpg";

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        outPath,
        quality: 70, // adjust quality (0-100)
        rotate: 0,
      );

      return File(compressedFile!.path);
    } else if (mimeType.contains('pdf')) {
      final tempdir = await getApplicationDocumentsDirectory();
      final outPutPath = '${tempdir.path}/temp.pdf';
      final compressedFile = await PdfCompressor.compressPdfFile(
        file.path,
        outPutPath,
        CompressQuality.MEDIUM, // or LOW, HIGH
      );

      return File(outPutPath);
    } else {
      return file;
    }
  }
}