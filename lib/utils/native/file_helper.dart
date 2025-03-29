import 'dart:io';

import 'package:archive/archive_io.dart';

class FileHelper {
  static void unzipFile(String targetArchiveFile, String outputFolder) {
    final inputStream = InputFileStream(targetArchiveFile);
    final archive = ZipDecoder().decodeStream(inputStream);
    for (var file in archive.files) {
      if (file.isFile) {
        final outputStream = OutputFileStream('$outputFolder/${file.name}');
        file.writeContent(outputStream);
        outputStream.close();
      }
    }
    inputStream.close();
  }

  static void extractRclone(String targetArchiveFile, String outputFolder) {
    final inputStream = InputFileStream(targetArchiveFile);
    final archive = ZipDecoder().decodeStream(inputStream);
    for (var file in archive.files) {
      if (file.isFile &&
          file.name.endsWith('rclone.exe') &&
          Platform.isWindows) {
        final outputStream = OutputFileStream('$outputFolder/rclone.exe');
        file.writeContent(outputStream);
        outputStream.close();
      } else if (file.isFile &&
          file.name.endsWith('rclone') &&
          !Platform.isWindows) {
        final outputStream = OutputFileStream('$outputFolder/rclone');
        file.writeContent(outputStream);
        outputStream.close();
      }
    }
    inputStream.close();
  }
}
