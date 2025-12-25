import 'package:dartz/dartz.dart';
import 'package:flutter_boilerplate/core/core.dart';
import 'package:flutter_boilerplate/features/settings/domain/repositories/settings_local_repositories.dart';

/// UseCase to save app settings to local storage
class SaveAppSettings implements UseCase<bool, AppSettings> {
  final SettingsLocalRepositories repository;

  SaveAppSettings(this.repository);

  @override
  Future<Either<Failure, bool>> call(AppSettings params) async {
    return await repository.saveSettings(params);
  }
}
