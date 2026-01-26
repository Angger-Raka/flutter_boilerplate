import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_boilerplate/core/error/failure.dart';
import 'package:flutter_boilerplate/core/services/secure_storage_service.dart';
import 'package:flutter_boilerplate/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_boilerplate/features/auth/domain/entities/user.dart';
import 'package:flutter_boilerplate/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // Save tokens securely
      await SecureStorageService.saveAccessToken(response.accessToken);
      if (response.refreshToken != null) {
        await SecureStorageService.saveRefreshToken(response.refreshToken!);
      }
      await SecureStorageService.saveUserId(response.user.id);

      debugPrint('🔐 Login successful for ${response.user.email}');
      return Right(response.user.toEntity());
    } catch (e) {
      debugPrint('🔐 Login failed: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Clear all secure storage
      await SecureStorageService.clearAll();
      debugPrint('🔐 Logout successful');
      return const Right(null);
    } catch (e) {
      debugPrint('🔐 Logout failed: $e');
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final hasToken = await SecureStorageService.hasAccessToken();
      if (!hasToken) {
        return const Right(null);
      }

      final user = await remoteDataSource.getCurrentUser();
      return Right(user.toEntity());
    } catch (e) {
      debugPrint('🔐 Get current user failed: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await SecureStorageService.hasAccessToken();
  }
}
