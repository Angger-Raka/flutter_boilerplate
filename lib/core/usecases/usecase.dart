import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_boilerplate/core/error/failure.dart';

/// Base class for all use cases in the application.
/// [Type] is the return type of the use case.
/// [Params] is the parameters required by the use case.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use this class when the use case does not require any parameters.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
