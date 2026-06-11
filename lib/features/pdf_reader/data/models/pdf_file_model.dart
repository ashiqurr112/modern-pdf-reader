import '../../domain/entities/pdf_file.dart';

class PdfFileModel extends PdfFile {
  const PdfFileModel({
    required super.path,
    required super.name,
    required super.size,
    required super.lastModified,
  });

  factory PdfFileModel.fromPath(String path, String name, int size, DateTime lastModified) {
    return PdfFileModel(
      path: path,
      name: name,
      size: size,
      lastModified: lastModified,
    );
  }
}
