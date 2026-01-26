import 'package:dartz/dartz.dart';
import 'package:flutter_boilerplate/core/error/failure.dart';
import 'package:flutter_boilerplate/core/usecases/usecase.dart';
import 'package:flutter_boilerplate/features/auth/domain/repositories/auth_repository.dart';

/// Logout use case
class Logout extends UseCase<void, NoParams> {
  final AuthRepository repository;

  Logout(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}
