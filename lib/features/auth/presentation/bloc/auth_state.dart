part of 'auth_bloc.dart';

final class AuthState extends Equatable implements BlocStateMixin {
  @override
  final BlocStatus status;
  final User? user;
  @override
  final String? errorMessage;

  const AuthState({
    this.status = BlocStatus.initial,
    this.user,
    this.errorMessage,
  });

  bool get isLoggedIn => user != null;

  AuthState copyWith({
    BlocStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
