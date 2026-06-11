import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/pdf_file.dart';
import '../repositories/pdf_repository.dart';

class GetRecentPdfFiles implements UseCase<(Failure?, List<PdfFile>?), NoParams> {
  final PdfRepository repository;

  GetRecentPdfFiles(this.repository);

  @override
  Future<(Failure?, List<PdfFile>?)> call(NoParams params) async {
    return await repository.getRecentPdfFiles();
  }
}
