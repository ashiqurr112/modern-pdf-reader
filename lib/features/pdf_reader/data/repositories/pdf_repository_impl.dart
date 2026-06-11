import '../../../../core/errors/failures.dart';
import '../../domain/entities/pdf_file.dart';
import '../../domain/repositories/pdf_repository.dart';
import '../datasources/local_pdf_scanner.dart';

class PdfRepositoryImpl implements PdfRepository {
  final LocalPdfScanner scanner;

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
}
