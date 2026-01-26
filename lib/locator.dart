import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/core.dart';
import 'package:flutter_boilerplate/features/settings/settings.dart';
import 'package:flutter_boilerplate/features/auth/auth.dart';
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

  // Auth Feature
  _setupAuthFeature();
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

void _setupAuthFeature() {
  // Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
    ),
  );

  // Use Cases
  getIt
    ..registerLazySingleton<Login>(
      () => Login(getIt<AuthRepository>()),
    )
    ..registerLazySingleton<Logout>(
      () => Logout(getIt<AuthRepository>()),
    )
    ..registerLazySingleton<GetCurrentUser>(
      () => GetCurrentUser(getIt<AuthRepository>()),
    );

  // BLoC
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      login: getIt<Login>(),
      logout: getIt<Logout>(),
      getCurrentUser: getIt<GetCurrentUser>(),
    ),
  );
}
