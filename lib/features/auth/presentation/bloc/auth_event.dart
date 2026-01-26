part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Check if user is already logged in
final class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Login with email and password
final class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Logout current user
final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
