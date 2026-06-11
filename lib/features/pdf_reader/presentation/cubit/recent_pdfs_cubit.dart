import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/add_recent_pdf.dart';
import '../../domain/usecases/get_recent_pdfs.dart';
import 'recent_pdfs_state.dart';

class RecentPdfsCubit extends Cubit<RecentPdfsState> {
  final GetRecentPdfFiles getRecentPdfFiles;
  final AddRecentPdf addRecentPdf;

  RecentPdfsCubit({required this.getRecentPdfFiles, required this.addRecentPdf}) : super(RecentPdfsInitial());

  void loadRecentFiles() async {
    emit(RecentPdfsLoading());
    final result = await getRecentPdfFiles(NoParams());
    final failure = result.$1;
    final files = result.$2;

    if (failure != null) {
      emit(RecentPdfsError(failure.message));
    } else if (files != null) {
      emit(RecentPdfsLoaded(files));
    }
  }

  void addFileToRecents(String path) async {
    await addRecentPdf(path);
    loadRecentFiles();
  }
}
