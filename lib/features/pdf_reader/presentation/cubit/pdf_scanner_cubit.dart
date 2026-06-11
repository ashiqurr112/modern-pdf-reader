import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/get_pdf_files.dart';
import 'pdf_scanner_state.dart';

class PdfScannerCubit extends Cubit<PdfScannerState> {
  final GetPdfFiles getPdfFiles;

  PdfScannerCubit({required this.getPdfFiles}) : super(PdfScannerInitial());

  void scanFiles() async {
    emit(PdfScannerLoading());
    final result = await getPdfFiles(NoParams());
    final failure = result.$1;
    final files = result.$2;

    if (failure != null) {
      if (failure is StoragePermissionFailure) {
        emit(PdfScannerPermissionDenied());
      } else {
        emit(PdfScannerError(failure.message));
      }
    } else if (files != null) {
      emit(PdfScannerLoaded(files, files));
    }
  }

  void search(String query) {
    if (state is PdfScannerLoaded) {
      final currentState = state as PdfScannerLoaded;
      if (query.isEmpty) {
        emit(PdfScannerLoaded(currentState.pdfs, currentState.pdfs));
      } else {
        final filtered = currentState.pdfs
            .where((pdf) => pdf.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
        emit(PdfScannerLoaded(currentState.pdfs, filtered));
      }
    }
  }
}
