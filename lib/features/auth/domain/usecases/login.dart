import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_boilerplate/core/error/failure.dart';
import 'package:flutter_boilerplate/core/usecases/usecase.dart';
import 'package:flutter_boilerplate/features/auth/domain/entities/user.dart';
import 'package:flutter_boilerplate/features/auth/domain/repositories/auth_repository.dart';

/// Login use case
class Login extends UseCase<User, LoginParams> {
  final AuthRepository repository;

  Login(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

/// Parameters for login
class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
