import 'package:equatable/equatable.dart';

class PdfFile extends Equatable {
  final String path;
  final String name;
  final int size;
  final DateTime lastModified;

  const PdfFile({
    required this.path,
    required this.name,
    required this.size,
    required this.lastModified,
  });

  @override
  List<Object> get props => [path, name, size, lastModified];
}
