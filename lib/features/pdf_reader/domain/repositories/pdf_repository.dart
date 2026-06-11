import '../../../../core/errors/failures.dart';
import '../entities/pdf_file.dart';

abstract class PdfRepository {
  Future<(Failure?, List<PdfFile>?)> getPdfFiles();
  Future<(Failure?, List<PdfFile>?)> getRecentPdfFiles();
  Future<Failure?> addRecentPdf(String path);
}
