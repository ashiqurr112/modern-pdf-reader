import 'package:equatable/equatable.dart';
import '../../domain/entities/pdf_file.dart';

abstract class RecentPdfsState extends Equatable {
  const RecentPdfsState();

  @override
  List<Object> get props => [];
}

class RecentPdfsInitial extends RecentPdfsState {}

class RecentPdfsLoading extends RecentPdfsState {}

class RecentPdfsLoaded extends RecentPdfsState {
  final List<PdfFile> pdfs;

  const RecentPdfsLoaded(this.pdfs);

  @override
  List<Object> get props => [pdfs];
}

class RecentPdfsError extends RecentPdfsState {
  final String message;

  const RecentPdfsError(this.message);

  @override
  List<Object> get props => [message];
}
