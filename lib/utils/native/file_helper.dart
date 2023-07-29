import 'package:archive/archive_io.dart';

class FileHelper {
  static void unzipFile(String targetArchiveFile, String outputFolder) {
    final inputStream = InputFileStream(targetArchiveFile);
    final archive = ZipDecoder().decodeBuffer(inputStream);
    for (var file in archive.files) {
      if (file.isFile) {
        final outputStream = OutputFileStream('$outputFolder/${file.name}');
        file.writeContent(outputStream);
        outputStream.close();
      }
    }
    inputStream.close();
  }
}
