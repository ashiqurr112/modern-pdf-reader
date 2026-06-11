import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class StoragePermissionFailure extends Failure {
  const StoragePermissionFailure([super.message = "Storage permission denied"]);
}

class StorageScanFailure extends Failure {
  const StorageScanFailure([super.message = "Failed to scan for PDF files"]);
}
