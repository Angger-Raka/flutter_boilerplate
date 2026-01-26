import 'package:flutter_boilerplate/features/auth/data/models/user_model.dart';

/// Remote data source for authentication
abstract class AuthRemoteDataSource {
  /// Login with email and password
  /// Returns user data and tokens
  Future<AuthResponse> login({
    required String email,
    required String password,
  });

  /// Get current user from API
  Future<UserModel> getCurrentUser();
}

/// Response from login API
class AuthResponse {
  final UserModel user;
  final String accessToken;
  final String? refreshToken;

  const AuthResponse({
    required this.user,
    required this.accessToken,
    this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String?,
    );
  }
}

/// Mock implementation for testing
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // In real app, inject DioClient here
  // final DioClient _dioClient;

  AuthRemoteDataSourceImpl();

  @override
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    // TODO: Replace with actual API call
    // final response = await _dioClient.dio.post('/auth/login', data: {
    //   'email': email,
    //   'password': password,
    // });
    // return AuthResponse.fromJson(response.data);

    // Mock response for testing
    await Future.delayed(const Duration(seconds: 1));

    // Simulate validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    if (password.length < 6) {
      throw Exception('Invalid credentials');
    }

    return AuthResponse(
      user: UserModel(
        id: '1',
        email: email,
        name: email.split('@').first,
        avatarUrl: null,
        createdAt: DateTime.now(),
      ),
      accessToken: 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_refresh_token',
    );
  }

  @override
  Future<UserModel> getCurrentUser() async {
    // TODO: Replace with actual API call
    // final response = await _dioClient.dio.get('/auth/me');
    // return UserModel.fromJson(response.data);

    // Mock response
    await Future.delayed(const Duration(milliseconds: 500));
    return UserModel(
      id: '1',
      email: 'user@example.com',
      name: 'Test User',
      avatarUrl: null,
      createdAt: DateTime.now(),
    );
  }
}
