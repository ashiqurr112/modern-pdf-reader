import 'package:equatable/equatable.dart';
import '../../domain/entities/pdf_file.dart';

abstract class PdfScannerState extends Equatable {
  const PdfScannerState();

  @override
  List<Object> get props => [];
}

class PdfScannerInitial extends PdfScannerState {}

class PdfScannerLoading extends PdfScannerState {}

class PdfScannerLoaded extends PdfScannerState {
  final List<PdfFile> pdfs;
  final List<PdfFile> filteredPdfs;

  const PdfScannerLoaded(this.pdfs, this.filteredPdfs);

  @override
  List<Object> get props => [pdfs, filteredPdfs];
}

class PdfScannerPermissionDenied extends PdfScannerState {}

class PdfScannerError extends PdfScannerState {
  final String message;

  const PdfScannerError(this.message);

  @override
  List<Object> get props => [message];
}
