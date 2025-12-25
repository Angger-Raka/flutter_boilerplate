import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_language.g.dart';

@JsonSerializable()
class AppLanguage extends Equatable {
  final String? name;
  final String? code;

  const AppLanguage({this.name, this.code});

  /// Predefined English language
  static const AppLanguage english = AppLanguage(
    name: 'English',
    code: 'en',
  );

  /// Predefined Indonesian language
  static const AppLanguage indonesian = AppLanguage(
    name: 'Bahasa Indonesia',
    code: 'id',
  );

  /// List of all supported languages
  static const List<AppLanguage> supportedLanguages = [english, indonesian];

  /// Get Locale from language code
  Locale get locale => Locale(code ?? 'en');

  /// Get language by code
  static AppLanguage fromCode(String? code) {
    switch (code) {
      case 'id':
        return indonesian;
      case 'en':
      default:
        return english;
    }
  }

  factory AppLanguage.fromJson(Map<String, dynamic> json) {
    return _$AppLanguageFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AppLanguageToJson(this);

  AppLanguage copyWith({String? name, String? code}) {
    return AppLanguage(name: name ?? this.name, code: code ?? this.code);
  }

  @override
  List<Object?> get props => [name, code];
}
