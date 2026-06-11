import 'package:get_it/get_it.dart';
import '../../features/pdf_reader/data/datasources/local_pdf_scanner.dart';
import '../../features/pdf_reader/data/repositories/pdf_repository_impl.dart';
import '../../features/pdf_reader/domain/repositories/pdf_repository.dart';
import '../../features/pdf_reader/domain/usecases/add_recent_pdf.dart';
import '../../features/pdf_reader/domain/usecases/get_pdf_files.dart';
import '../../features/pdf_reader/domain/usecases/get_recent_pdfs.dart';
import '../../features/pdf_reader/presentation/cubit/pdf_scanner_cubit.dart';
import '../../features/pdf_reader/presentation/cubit/recent_pdfs_cubit.dart';

final sl = GetIt.instance;

void setupLocator() {
  // Cubit
  sl.registerFactory(() => PdfScannerCubit(getPdfFiles: sl()));
  sl.registerFactory(() => RecentPdfsCubit(getRecentPdfFiles: sl(), addRecentPdf: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetPdfFiles(sl()));
  sl.registerLazySingleton(() => GetRecentPdfFiles(sl()));
  sl.registerLazySingleton(() => AddRecentPdf(sl()));

  // Repository
  sl.registerLazySingleton<PdfRepository>(
    () => PdfRepositoryImpl(scanner: sl()),
  );

  // Data sources
  sl.registerLazySingleton<LocalPdfScanner>(
    () => LocalPdfScannerImpl(),
  );
}
