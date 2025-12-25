part of 'app_settings_bloc.dart';

sealed class AppSettingsEvent extends Equatable {
  const AppSettingsEvent();

  @override
  List<Object> get props => [];
}

final class LoadSettings extends AppSettingsEvent {
  const LoadSettings();
}

final class ChangeEnvironment extends AppSettingsEvent {
  final EnvType envType;

  const ChangeEnvironment(this.envType);

  @override
  List<Object> get props => [envType];
}

final class ChangeLanguage extends AppSettingsEvent {
  final AppLanguage language;

  const ChangeLanguage(this.language);

  @override
  List<Object> get props => [language];
}

final class ChangeThemeMode extends AppSettingsEvent {
  final ThemeMode themeMode;

  const ChangeThemeMode(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}
