# 📚 Flutter Boilerplate - Documentation
# Dokumentasi Flutter Boilerplate

> **Flutter Version**: 3.29.0 | **Dart Version**: 3.7.0

---

## Table of Contents / Daftar Isi

1. [Quick Start / Mulai Cepat](#quick-start--mulai-cepat)
2. [Project Structure / Struktur Project](#project-structure--struktur-project)
3. [Clean Architecture](#clean-architecture)
4. [BLoC Pattern](#bloc-pattern)
5. [Flavors / Environment](#flavors--environment)
6. [Firebase Services](#firebase-services)
7. [Localization / Lokalisasi](#localization--lokalisasi)
8. [Theming](#theming)
9. [Adding New Feature / Menambahkan Fitur Baru](#adding-new-feature--menambahkan-fitur-baru)
10. [Best Practices](#best-practices)

---

## Quick Start / Mulai Cepat

### Prerequisites / Prasyarat

```bash
# Check Flutter version / Cek versi Flutter
flutter --version
# Flutter 3.29.0 or higher

# Check Dart version / Cek versi Dart  
dart --version
# Dart 3.7.0 or higher
```

### First Time Setup / Setup Pertama Kali

```bash
# 1. Clone repository
git clone https://github.com/your-username/flutter-boilerplate.git
cd flutter-boilerplate

# 2. Install dependencies
flutter pub get

# 3. Generate localization / Generate lokalisasi
flutter gen-l10n

# 4. Generate code (models) / Generate kode (model)
dart run build_runner build --delete-conflicting-outputs

# 5. (Optional) Setup Firebase
dart pub global activate flutterfire_cli
flutterfire configure

# 6. Run app / Jalankan aplikasi
flutter run --flavor dev
```

---

## Project Structure / Struktur Project

```
lib/
├── app.dart                    # Root widget with MaterialApp
├── main.dart                   # Entry point & Firebase init
├── locator.dart                # Dependency Injection (GetIt)
├── router.dart                 # Route definitions (GoRouter)
│
├── core/                       # Shared code across features
│   ├── common/                 
│   │   └── entities/           # Shared entities (AppSettings, AppLanguage)
│   │
│   ├── config/                 
│   │   ├── app_env.dart        # Environment configuration
│   │   ├── app_preference.dart # Preference keys & wrapper
│   │   └── dio_client.dart     # HTTP client with interceptors
│   │
│   ├── constants/              # App constants
│   ├── error/                  # Failure classes
│   │
│   ├── services/               
│   │   ├── local_storage_service.dart  # SharedPreferences wrapper
│   │   └── firebase/                   # Firebase services
│   │       ├── firebase_service.dart   # Firebase init
│   │       ├── analytics_service.dart  # Analytics
│   │       ├── crashlytics_service.dart # Crash reporting
│   │       ├── messaging_service.dart   # Push notifications
│   │       └── remote_config_service.dart # Feature flags
│   │
│   ├── themes/                 # App themes
│   ├── usecases/               # Base UseCase class
│   ├── utils/                  # Utilities & extensions
│   └── widgets/                # Reusable widgets
│
├── features/                   # Feature modules
│   └── settings/
│       ├── data/               # Data Layer
│       ├── domain/             # Domain Layer  
│       └── presentation/       # Presentation Layer
│
└── l10n/                       # Localization
    ├── app_en.arb              # English
    └── app_id.arb              # Indonesian
```

---

## Clean Architecture

This boilerplate follows Clean Architecture with 3 layers:

### 1. Data Layer (Outer)
- **DataSources**: API calls, local database
- **Models**: JSON serializable classes
- **Repositories**: Implementation of domain interfaces

### 2. Domain Layer (Core)
- **Entities**: Business objects
- **Repositories**: Abstract interfaces
- **UseCases**: Business logic

### 3. Presentation Layer (Outer)
- **BLoC**: State management
- **Pages**: Screen widgets
- **Widgets**: UI components

### Data Flow

```
User Action → UI → BLoC Event → UseCase → Repository → DataSource → API/DB
                                    ↓
Response → DataSource → Repository → UseCase → BLoC State → UI Update
```

---

## BLoC Pattern

### Event → BLoC → State

```dart
// 1. Define Events
sealed class AppSettingsEvent extends Equatable {
  const AppSettingsEvent();
}

final class LoadSettings extends AppSettingsEvent {}
final class ChangeLanguage extends AppSettingsEvent {
  final AppLanguage language;
  const ChangeLanguage(this.language);
}

// 2. Define States
enum AppSettingsStatus { initial, loading, loaded, error }

final class AppSettingsState extends Equatable {
  final AppSettingsStatus status;
  final AppSettings settings;
  final String? errorMessage;
  // ...
}

// 3. BLoC handles events
class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  AppSettingsBloc() : super(const AppSettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<ChangeLanguage>(_onChangeLanguage);
  }
}
```

### Usage in UI

```dart
// Dispatch event
context.read<AppSettingsBloc>().add(const LoadSettings());

// Listen to state
BlocBuilder<AppSettingsBloc, AppSettingsState>(
  builder: (context, state) {
    if (state.status == AppSettingsStatus.loading) {
      return CircularProgressIndicator();
    }
    return Text(state.settings.language.name);
  },
);
```

---

## Flavors / Environment

### Available Flavors

| Flavor | Bundle ID Suffix | API |
|--------|-----------------|-----|
| `dev` | `.dev` | Development API |
| `staging` | `.staging` | Staging API |
| `prod` | (none) | Production API |

### Run Commands

```bash
# Development
flutter run --flavor dev

# Staging
flutter run --flavor staging

# Production  
flutter run --flavor prod

# Build APK
flutter build apk --flavor prod --release

# Build iOS
flutter build ios --flavor prod --release
```

### Configure API URLs

Edit `lib/core/config/app_env.dart`:

```dart
static const Map<EnvType, String> _baseUrls = {
  EnvType.dev: 'https://your-dev-api.com',
  EnvType.staging: 'https://your-staging-api.com',
  EnvType.prod: 'https://your-prod-api.com',
};
```

---

## Firebase Services

### Setup

```bash
# 1. Install CLI
dart pub global activate flutterfire_cli

# 2. Configure (follow prompts)
flutterfire configure
```

### Available Services

#### Analytics Service
```dart
// Log screen view
AnalyticsService.logScreenView(screenName: 'HomeScreen');

// Log custom event
AnalyticsService.logEvent(
  name: 'purchase',
  parameters: {'item': 'premium', 'price': 9.99},
);

// Set user ID
AnalyticsService.setUserId('user_123');
```

#### Crashlytics Service
```dart
// Log error
CrashlyticsService.recordError(exception, stackTrace);

// Log message
CrashlyticsService.log('User did something');

// Set user identifier
CrashlyticsService.setUserIdentifier('user_123');
```

#### Messaging Service (FCM)
```dart
// Get FCM token
final token = MessagingService.fcmToken;

// Subscribe to topic
MessagingService.subscribeToTopic('news');

// Show local notification
MessagingService.showLocalNotification(
  title: 'Hello',
  body: 'New message!',
);
```

#### Remote Config Service
```dart
// Get feature flag
final isNewUI = RemoteConfigService.getBool('feature_new_ui');

// Get string value
final welcomeText = RemoteConfigService.getString('welcome_text');

// Get int value
final maxRetries = RemoteConfigService.getInt('max_retries');
```

---

## Localization / Lokalisasi

### Supported Languages
- 🇬🇧 English (en)
- 🇮🇩 Indonesian (id)

### Add New Strings

1. Edit `lib/l10n/app_en.arb`:
```json
{
  "hello": "Hello",
  "@hello": {
    "description": "Greeting message"
  }
}
```

2. Edit `lib/l10n/app_id.arb`:
```json
{
  "hello": "Halo"
}
```

3. Generate:
```bash
flutter gen-l10n
```

### Use in Code

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// In widget
final l10n = AppLocalizations.of(context)!;
Text(l10n.hello); // "Hello" or "Halo"
```

---

## Theming

### Available Themes
- Light Mode
- Dark Mode
- System Default

### Change Theme Programmatically

```dart
context.read<AppSettingsBloc>().add(
  ChangeThemeMode(ThemeMode.dark),
);
```

### Customize Theme

Edit `lib/app.dart`:

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,  // Change primary color
    brightness: Brightness.light,
  ),
  useMaterial3: true,
),
```

---

## Adding New Feature / Menambahkan Fitur Baru

### Step-by-Step

1. **Create folder structure**:
```
lib/features/your_feature/
├── data/
│   ├── datasources/
│   │   └── your_feature_datasource.dart
│   ├── models/
│   │   └── your_model.dart
│   └── repositories/
│       └── your_feature_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── your_entity.dart
│   ├── repositories/
│   │   └── your_feature_repository.dart
│   └── usecases/
│       └── get_your_data.dart
└── presentation/
    ├── bloc/
    │   └── your_feature_bloc/
    ├── pages/
    │   └── your_feature_page.dart
    └── widgets/
```

2. **Register in `locator.dart`**:
```dart
// DataSources
getIt.registerLazySingleton<YourDataSource>(
  () => YourDataSourceImpl(),
);

// Repository
getIt.registerLazySingleton<YourRepository>(
  () => YourRepositoryImpl(getIt<YourDataSource>()),
);

// UseCase
getIt.registerLazySingleton<GetYourData>(
  () => GetYourData(getIt<YourRepository>()),
);

// BLoC
getIt.registerFactory<YourFeatureBloc>(
  () => YourFeatureBloc(getIt<GetYourData>()),
);
```

3. **Add route in `router.dart`**:
```dart
GoRoute(
  path: '/your-feature',
  builder: (context, state) => const YourFeaturePage(),
),
```

---

## Best Practices

### ✅ Do's

1. **Use BLoC for state management** - Keeps UI and logic separate
2. **Follow Clean Architecture** - Makes testing easier
3. **Use `Either<Failure, Success>`** - Explicit error handling
4. **Register all dependencies** - Use GetIt for DI
5. **Use const constructors** - Better performance
6. **Localize all strings** - Easy i18n support
7. **Use flavors** - Separate environments
8. **Log crashes to Crashlytics** - Monitor production issues

### ❌ Don'ts

1. **Don't call API directly from UI** - Use UseCases
2. **Don't put business logic in widgets** - Use BLoC
3. **Don't hardcode strings** - Use localization
4. **Don't hardcode API URLs** - Use environment config
5. **Don't ignore errors** - Handle with `Either`

---

## Commands Cheat Sheet

```bash
# Install dependencies
flutter pub get

# Generate localizations
flutter gen-l10n

# Generate code (JSON serialization)
dart run build_runner build --delete-conflicting-outputs

# Watch for changes (development)
dart run build_runner watch

# Run with flavor
flutter run --flavor dev
flutter run --flavor staging
flutter run --flavor prod

# Build
flutter build apk --flavor prod --release
flutter build ios --flavor prod --release

# Analyze code
flutter analyze

# Test
flutter test
```

---

**Happy Coding!** 🚀
