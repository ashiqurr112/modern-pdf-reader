import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import '../models/pdf_file_model.dart';

abstract class LocalPdfScanner {
  Future<List<PdfFileModel>> scanForPdfs();
}

class LocalPdfScannerImpl implements LocalPdfScanner {
  @override
  Future<List<PdfFileModel>> scanForPdfs() async {
    List<PdfFileModel> pdfFiles = [];

    // Request permissions
    bool hasPermission = await _requestPermissions();
    if (!hasPermission) {
      throw Exception('Storage permission denied');
    }

    try {
      Directory dir = Directory('/storage/emulated/0');
      if (await dir.exists()) {
        await _scanDirectory(dir, pdfFiles);
      }
    } catch (e) {
      throw Exception('Failed to scan directories: $e');
    }

    // Sort by last modified descending
    pdfFiles.sort((a, b) => b.lastModified.compareTo(a.lastModified));
    return pdfFiles;
  }

  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.request().isGranted) {
        return true;
      }
      if (await Permission.storage.request().isGranted) {
        return true;
      }
      return false;
    }
    return true;
  }

  Future<void> _scanDirectory(Directory dir, List<PdfFileModel> pdfFiles) async {
    try {
      List<FileSystemEntity> entities = await dir.list(followLinks: false).toList();
      for (var entity in entities) {
        if (entity is File && entity.path.toLowerCase().endsWith('.pdf')) {
          try {
            final stat = await entity.stat();
            pdfFiles.add(PdfFileModel.fromPath(
              entity.path,
              p.basename(entity.path),
              stat.size,
              stat.modified,
            ));
          } catch (_) {
            // Ignore file stat errors
          }
        } else if (entity is Directory) {
          String folderName = p.basename(entity.path);
          // Skip system folders and hidden folders to speed up scanning and avoid permission issues
          if (!folderName.startsWith('.') && folderName != 'Android') {
             await _scanDirectory(entity, pdfFiles);
          }
        }
      }
    } catch (_) {
      // Ignore directory access errors (e.g., restricted folders)
    }
  }
}
