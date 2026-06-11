import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/pdf_file.dart';
import '../../domain/repositories/pdf_repository.dart';
import '../datasources/local_pdf_scanner.dart';
import '../models/pdf_file_model.dart';

class PdfRepositoryImpl implements PdfRepository {
  final LocalPdfScanner scanner;
  static const String _recentsKey = 'recent_pdfs';

  PdfRepositoryImpl({required this.scanner});

  @override
  Future<(Failure?, List<PdfFile>?)> getPdfFiles() async {
    try {
      final files = await scanner.scanForPdfs();
      return (null, files);
    } catch (e) {
      if (e.toString().contains('permission')) {
        return (const StoragePermissionFailure(), null);
      }
      return (const StorageScanFailure(), null);
    }
  }

  @override
  Future<(Failure?, List<PdfFile>?)> getRecentPdfFiles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recentPaths = prefs.getStringList(_recentsKey) ?? [];
      
      List<PdfFile> recentPdfs = [];
      for (String path in recentPaths) {
        File file = File(path);
        if (await file.exists()) {
          final stat = await file.stat();
          recentPdfs.add(PdfFileModel.fromPath(
            path,
            p.basename(path),
            stat.size,
            stat.modified,
          ));
        }
      }
      return (null, recentPdfs);
    } catch (e) {
      return (const StorageScanFailure("Failed to load recent PDFs"), null);
    }
  }

  @override
  Future<Failure?> addRecentPdf(String path) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> recentPaths = prefs.getStringList(_recentsKey) ?? [];
      
      // Remove if it already exists to put it at the front
      recentPaths.remove(path);
      recentPaths.insert(0, path);
      
      // Keep only top 10
      if (recentPaths.length > 10) {
        recentPaths = recentPaths.sublist(0, 10);
      }
      
      await prefs.setStringList(_recentsKey, recentPaths);
      return null;
    } catch (e) {
      return const StorageScanFailure("Failed to save recent PDF");
    }
  }
}
