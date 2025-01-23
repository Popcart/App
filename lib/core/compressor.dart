import 'dart:developer';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:mime/mime.dart';
import 'package:pdf_compressor/pdf_compressor.dart';

class FileCompressor {
  static Future<File> compressFile(File file) async {
    final mimeType = lookupMimeType(file.path) ?? '';
    log(mimeType, name: 'Mime Type');
    if (mimeType.contains('image')) {
      final filePath = file.absolute.path;
      final lastIndex = filePath.lastIndexOf(RegExp('.jp|.png'));
      final splitted = filePath.substring(0, lastIndex);
      final outPath = '${splitted}_compressed.jpg';

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        outPath,
        quality: 70, // adjust quality (0-100)
      );

      return File(compressedFile!.path);
    } else if (mimeType.contains('pdf')) {
      try {
        // final tempdir = await getTemporaryDirectory();
        // await  Directory('${tempdir.path}/compressed').create(recursive: true);
        // final outPutPath = '${tempdir.path}/compressed/temp.pdf';
        // log(outPutPath, name: 'Output Path');
        await PdfCompressor.compressPdfFile(
          file.path,
          file.path,
          CompressQuality.MEDIUM, // or LOW, HIGH
        );

        return File(file.path);
      } catch (e) {
        log(e.toString(), name: 'Error');
        return file;
      }
    } else {
      return file;
    }
  }
}
