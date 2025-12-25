import 'package:dartz/dartz.dart';
import 'package:flutter_boilerplate/core/core.dart';
import 'package:flutter_boilerplate/features/settings/domain/repositories/settings_local_repositories.dart';

/// UseCase to get app settings from local storage
class GetAppSettings implements UseCase<AppSettings, NoParams> {
  final SettingsLocalRepositories repository;

  GetAppSettings(this.repository);

  @override
  Future<Either<Failure, AppSettings>> call(NoParams params) async {
    return await repository.getSettings();
  }
}
