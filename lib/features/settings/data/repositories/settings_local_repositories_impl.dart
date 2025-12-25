import 'package:dartz/dartz.dart';
import 'package:flutter_boilerplate/core/core.dart';
import 'package:flutter_boilerplate/features/settings/settings.dart';

class SettingsLocalRepositoriesImpl implements SettingsLocalRepositories {
  SettingsLocalRepositoriesImpl({required this.settingsLocalDataSources});

  final SettingsLocalDataSources settingsLocalDataSources;

  @override
  Future<Either<Failure, bool>> init() async {
    try {
      await settingsLocalDataSources.init();
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppSettings>> getSettings() async {
    try {
      final settings = await settingsLocalDataSources.getSettings();
      return Right(settings);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> saveSettings(AppSettings settings) async {
    try {
      await settingsLocalDataSources.saveSettings(settings);
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateSettings(AppSettings settings) async {
    try {
      await settingsLocalDataSources.updateSettings(settings);
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> clearSettings() async {
    try {
      await settingsLocalDataSources.clearSettings();
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
