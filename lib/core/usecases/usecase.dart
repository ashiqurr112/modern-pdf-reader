import 'package:equatable/equatable.dart';

abstract class UseCase<ReturnType, Params> {
  Future<ReturnType> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
