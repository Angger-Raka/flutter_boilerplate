import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/core.dart';
import 'package:flutter_boilerplate/features/settings/domain/usecases/get_app_settings.dart';
import 'package:flutter_boilerplate/features/settings/domain/usecases/save_app_settings.dart';

part 'app_settings_event.dart';
part 'app_settings_state.dart';

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  final GetAppSettings getAppSettings;
  final SaveAppSettings saveAppSettings;
  final DioClient? dioClient;

  AppSettingsBloc({
    required this.getAppSettings,
    required this.saveAppSettings,
    this.dioClient,
  }) : super(const AppSettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<ChangeEnvironment>(_onChangeEnvironment);
    on<ChangeLanguage>(_onChangeLanguage);
    on<ChangeThemeMode>(_onChangeThemeMode);
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<AppSettingsState> emit,
  ) async {
    emit(state.copyWith(status: AppSettingsStatus.loading));

    final result = await getAppSettings(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        status: AppSettingsStatus.error,
        errorMessage: failure.message,
      )),
      (settings) {
        dioClient?.updateEnvironment(settings.environment);
        emit(state.copyWith(
          status: AppSettingsStatus.loaded,
          settings: settings,
        ));
      },
    );
  }

  Future<void> _onChangeEnvironment(
    ChangeEnvironment event,
    Emitter<AppSettingsState> emit,
  ) async {
    final newSettings = state.settings.copyWith(envType: event.envType);
    await _updateSettings(newSettings, emit);
    dioClient?.updateEnvironment(event.envType);
  }

  Future<void> _onChangeLanguage(
    ChangeLanguage event,
    Emitter<AppSettingsState> emit,
  ) async {
    final newSettings = state.settings.copyWith(appLanguage: event.language);
    await _updateSettings(newSettings, emit);
  }

  Future<void> _onChangeThemeMode(
    ChangeThemeMode event,
    Emitter<AppSettingsState> emit,
  ) async {
    final newSettings = state.settings.copyWith(appThemeMode: event.themeMode);
    await _updateSettings(newSettings, emit);
  }

  Future<void> _updateSettings(
    AppSettings newSettings,
    Emitter<AppSettingsState> emit,
  ) async {
    emit(state.copyWith(status: AppSettingsStatus.loading));

    final result = await saveAppSettings(newSettings);

    result.fold(
      (failure) => emit(state.copyWith(
        status: AppSettingsStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        status: AppSettingsStatus.loaded,
        settings: newSettings,
      )),
    );
  }
}
