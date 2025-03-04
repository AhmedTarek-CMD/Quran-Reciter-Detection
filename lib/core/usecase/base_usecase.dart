import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quran/core/error/failures.dart';

abstract class BaseUseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// This will be used by the code calling the use case whenever the use case
// doesn't accept any parameters.
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}