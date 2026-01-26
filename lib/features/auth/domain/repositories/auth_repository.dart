import 'package:dartz/dartz.dart';
import 'package:flutter_boilerplate/core/error/failure.dart';
import 'package:flutter_boilerplate/features/auth/domain/entities/user.dart';

/// Abstract repository for authentication
abstract class AuthRepository {
  /// Login with email and password
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Logout current user
  Future<Either<Failure, void>> logout();

  /// Get current logged in user
  Future<Either<Failure, User?>> getCurrentUser();

  /// Check if user is logged in
  Future<bool> isLoggedIn();
}
