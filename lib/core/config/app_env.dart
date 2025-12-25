import 'package:json_annotation/json_annotation.dart';

enum EnvType {
  @JsonValue('dev')
  dev,

  @JsonValue('staging')
  staging,

  @JsonValue('prod')
  prod,
}

extension EnvTypeX on EnvType {
  String get label {
    switch (this) {
      case EnvType.dev:
        return "Development";
      case EnvType.staging:
        return "Staging";
      case EnvType.prod:
        return "Production";
    }
  }

  String get code {
    switch (this) {
      case EnvType.dev:
        return 'dev';
      case EnvType.staging:
        return 'staging';
      case EnvType.prod:
        return 'prod';
    }
  }

  static EnvType fromCode(String code) {
    switch (code) {
      case 'staging':
        return EnvType.staging;
      case 'prod':
        return EnvType.prod;
      default:
        return EnvType.dev;
    }
  }
}

/// Configuration class for environment-specific settings
class EnvironmentConfig {
  EnvironmentConfig._();

  static const Map<EnvType, String> _baseUrls = {
    EnvType.dev: 'https://dev-api.example.com',
    EnvType.staging: 'https://staging-api.example.com',
    EnvType.prod: 'https://api.example.com',
  };

  /// Get base URL for the given environment
  static String getBaseUrl(EnvType env) {
    return _baseUrls[env] ?? _baseUrls[EnvType.dev]!;
  }

  /// Default environment
  static const EnvType defaultEnv = EnvType.dev;
}
