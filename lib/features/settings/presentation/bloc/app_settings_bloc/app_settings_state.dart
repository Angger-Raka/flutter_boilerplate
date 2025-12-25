part of 'app_settings_bloc.dart';

enum AppSettingsStatus { initial, loading, loaded, error }

final class AppSettingsState extends Equatable {
  final AppSettingsStatus status;
  final AppSettings settings;
  final String? errorMessage;

  const AppSettingsState({
    this.status = AppSettingsStatus.initial,
    AppSettings? settings,
    this.errorMessage,
  }) : settings = settings ?? const AppSettings();

  AppSettingsState copyWith({
    AppSettingsStatus? status,
    AppSettings? settings,
    String? errorMessage,
  }) {
    return AppSettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, settings, errorMessage];
}
