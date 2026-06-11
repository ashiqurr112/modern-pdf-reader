import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/pdf_repository.dart';

class AddRecentPdf implements UseCase<Failure?, String> {
  final PdfRepository repository;

  AddRecentPdf(this.repository);

  @override
  Future<Failure?> call(String params) async {
    return await repository.addRecentPdf(params);
  }
}
