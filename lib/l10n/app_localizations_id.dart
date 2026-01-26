// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Flutter Boilerplate';

  @override
  String get settings => 'Pengaturan';

  @override
  String get environment => 'Lingkungan';

  @override
  String get environmentDescription => 'Pilih lingkungan API';

  @override
  String get language => 'Bahasa';

  @override
  String get languageDescription => 'Pilih bahasa yang Anda inginkan';

  @override
  String get theme => 'Tema';

  @override
  String get themeDescription => 'Pilih tema yang Anda inginkan';

  @override
  String get development => 'Pengembangan';

  @override
  String get staging => 'Staging';

  @override
  String get production => 'Produksi';

  @override
  String get english => 'English';

  @override
  String get indonesian => 'Bahasa Indonesia';

  @override
  String get systemDefault => 'Sistem';

  @override
  String get lightMode => 'Terang';

  @override
  String get darkMode => 'Gelap';

  @override
  String get restartRequired =>
      'Aplikasi mungkin perlu di-restart agar beberapa perubahan diterapkan';
}
