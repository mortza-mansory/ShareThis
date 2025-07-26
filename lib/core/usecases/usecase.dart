import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart' show Equatable;
import 'package:sharethis/core/errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class StreamUseCase<Type, Params> {
  Stream<Type> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

class VoidResult extends Equatable {
  @override
  List<Object?> get props => [];
}