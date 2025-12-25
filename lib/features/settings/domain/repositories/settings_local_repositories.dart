import 'package:dartz/dartz.dart';
import 'package:flutter_boilerplate/core/core.dart';

abstract class SettingsLocalRepositories {
  Future<Either<Failure, bool>> init();
  Future<Either<Failure, AppSettings>> getSettings();
  Future<Either<Failure, bool>> saveSettings(AppSettings settings);
  Future<Either<Failure, bool>> updateSettings(AppSettings settings);
  Future<Either<Failure, bool>> clearSettings();
}
