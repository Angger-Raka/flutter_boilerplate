import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/core.dart';
import 'package:flutter_boilerplate/features/settings/settings.dart';
import 'package:flutter_boilerplate/router.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  await setupCore();
  await setupFeatures();
}

Future<void> setupCore() async {
  final prefs = await SharedPreferences.getInstance();
  final dio = Dio();

  // Core Services
  getIt
    ..registerLazySingleton<SharedPreferences>(() => prefs)
    ..registerLazySingleton<AppPreference>(() => AppPreference(prefs))
    ..registerLazySingleton<LocalStorageService>(
      () => LocalStorageService(sharedPreferences: prefs),
    )
    ..registerLazySingleton<DioClient>(
      () => DioClient(
        dio: dio,
        prefs: getIt<AppPreference>(),
        router: router,
      ),
    )
    ..registerLazySingleton<Dio>(() => getIt<DioClient>().client);
}

Future<void> setupFeatures() async {
  // Settings Feature
  _setupSettingsFeature();
}

void _setupSettingsFeature() {
  // Data Sources
  getIt.registerLazySingleton<SettingsLocalDataSources>(
    () => SettingsLocalDataSourcesImpl(
      localStorageService: getIt<LocalStorageService>(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<SettingsLocalRepositories>(
    () => SettingsLocalRepositoriesImpl(
      settingsLocalDataSources: getIt<SettingsLocalDataSources>(),
    ),
  );

  // Use Cases
  getIt
    ..registerLazySingleton<GetAppSettings>(
      () => GetAppSettings(getIt<SettingsLocalRepositories>()),
    )
    ..registerLazySingleton<SaveAppSettings>(
      () => SaveAppSettings(getIt<SettingsLocalRepositories>()),
    );

  // BLoC
  getIt.registerFactory<AppSettingsBloc>(
    () => AppSettingsBloc(
      getAppSettings: getIt<GetAppSettings>(),
      saveAppSettings: getIt<SaveAppSettings>(),
      dioClient: getIt<DioClient>(),
    ),
  );
}
