import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/core/usecases/usecase.dart';
import 'package:flutter_boilerplate/core/widgets/bloc/bloc_state_builder.dart';
import 'package:flutter_boilerplate/features/auth/domain/entities/user.dart';
import 'package:flutter_boilerplate/features/auth/domain/usecases/login.dart';
import 'package:flutter_boilerplate/features/auth/domain/usecases/logout.dart';
import 'package:flutter_boilerplate/features/auth/domain/usecases/get_current_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login _login;
  final Logout _logout;
  final GetCurrentUser _getCurrentUser;

  AuthBloc({
    required Login login,
    required Logout logout,
    required GetCurrentUser getCurrentUser,
  })  : _login = login,
        _logout = logout,
        _getCurrentUser = getCurrentUser,
        super(const AuthState()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final result = await _getCurrentUser(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        status: BlocStatus.success,
        user: null,
      )),
      (user) => emit(state.copyWith(
        status: BlocStatus.success,
        user: user,
      )),
    );
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final result = await _login(LoginParams(
      email: event.email,
      password: event.password,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: BlocStatus.error,
        errorMessage: failure.message,
      )),
      (user) => emit(state.copyWith(
        status: BlocStatus.success,
        user: user,
      )),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final result = await _logout(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        status: BlocStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        status: BlocStatus.success,
        user: null,
      )),
    );
  }
}
