// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flutter Boilerplate';

  @override
  String get settings => 'Settings';

  @override
  String get environment => 'Environment';

  @override
  String get environmentDescription => 'Select the API environment';

  @override
  String get language => 'Language';

  @override
  String get languageDescription => 'Select your preferred language';

  @override
  String get theme => 'Theme';

  @override
  String get themeDescription => 'Select your preferred theme';

  @override
  String get development => 'Development';

  @override
  String get staging => 'Staging';

  @override
  String get production => 'Production';

  @override
  String get english => 'English';

  @override
  String get indonesian => 'Bahasa Indonesia';

  @override
  String get systemDefault => 'System';

  @override
  String get lightMode => 'Light';

  @override
  String get darkMode => 'Dark';

  @override
  String get restartRequired =>
      'App restart may be required for some changes to take effect';
}
