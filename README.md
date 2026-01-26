# Flutter Boilerplate

<p align="center">
  <img src="https://flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup.png" alt="Flutter Logo" width="300"/>
</p>

<p align="center">
  <strong>A production-ready Flutter boilerplate with Clean Architecture, BLoC Pattern, and best practices.</strong>
</p>

<p align="center">
  <a href="README.id.md">🇮🇩 Bahasa Indonesia</a>
</p>

---

## ✨ Features

- 🏗️ **Clean Architecture** - Separation of concerns with Data, Domain, and Presentation layers
- 📦 **BLoC Pattern** - Predictable state management
- 🌍 **Multi-Environment** - Dev, Staging, Production flavors for Android & iOS
- 🌐 **Localization** - Ready for multiple languages (English & Indonesian included)
- 🎨 **Theme Switching** - Light, Dark, and System themes
- 💉 **Dependency Injection** - Using GetIt for service locator
- 🔄 **Dio HTTP Client** - With retry interceptor and logging
- 💾 **Local Storage** - SharedPreferences implementation
- 🛣️ **GoRouter** - Declarative routing
- 🔥 **Firebase Ready** - Analytics, Crashlytics, Push Notifications, Remote Config

---

## 📁 Project Structure

```
lib/
├── app.dart                    # Root application widget
├── main.dart                   # Entry point
├── locator.dart                # Dependency injection setup
├── router.dart                 # Route configuration
├── core/                       # Core utilities & shared code
│   ├── common/                 # Shared entities
│   ├── config/                 # App configuration (DioClient, Environment)
│   ├── constants/              # App constants
│   ├── error/                  # Failure classes
│   ├── services/               # Core services
│   ├── themes/                 # App themes
│   ├── usecases/               # Base UseCase class
│   ├── utils/                  # Utilities & extensions
│   └── widgets/                # Reusable widgets
├── features/                   # Feature modules
│   └── settings/               # Settings feature
│       ├── data/               # Data layer
│       │   ├── datasources/    # Local/Remote data sources
│       │   ├── models/         # Data models
│       │   └── repositories/   # Repository implementations
│       ├── domain/             # Domain layer
│       │   ├── entities/       # Business entities
│       │   ├── repositories/   # Repository interfaces
│       │   └── usecases/       # Use cases
│       └── presentation/       # Presentation layer
│           ├── bloc/           # BLoC state management
│           ├── pages/          # Screen widgets
│           └── widgets/        # Feature-specific widgets
└── l10n/                       # Localization files
    ├── app_en.arb              # English translations
    └── app_id.arb              # Indonesian translations
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.5.0 or higher
- Dart SDK 3.5.0 or higher
- Android Studio / VS Code
- Xcode (for iOS development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/flutter-boilerplate.git
   cd flutter-boilerplate
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate localization files**
   ```bash
   flutter gen-l10n
   ```

4. **Generate code (JSON serialization)**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Run the app**
   ```bash
   flutter run --flavor dev
   ```

---

## 🔄 Rename Project (For New Projects)

When using this boilerplate for a new project, run the rename script:

```bash
# Make script executable (first time only)
chmod +x scripts/rename_project.sh

# Rename project
./scripts/rename_project.sh my_app_name com.yourcompany.myapp
```

**Example:**
```bash
./scripts/rename_project.sh calculator com.example.calculator
```

The script will automatically update:
- ✅ All Dart package imports
- ✅ pubspec.yaml
- ✅ Android (build.gradle.kts, AndroidManifest.xml, MainActivity.kt)
- ✅ iOS (project.pbxproj)
- ✅ Web, macOS, Linux, Windows configs

---

## 🏃 Running the App

### With Flavors (Recommended)

```bash
# Development
flutter run --flavor dev

# Staging
flutter run --flavor staging

# Production
flutter run --flavor prod
```

### Build APK

```bash
# Debug
flutter build apk --flavor dev --debug

# Release
flutter build apk --flavor prod --release
```

### Build iOS

```bash
flutter build ios --flavor prod --release
```

---

## 🌍 Environment Configuration

The app supports multiple environments with different API endpoints:

| Environment | API URL | Bundle ID Suffix |
|-------------|---------|------------------|
| Development | `https://dev-api.example.com` | `.dev` |
| Staging | `https://staging-api.example.com` | `.staging` |
| Production | `https://api.example.com` | (none) |

Configure URLs in `lib/core/config/app_env.dart`:

```dart
static const Map<EnvType, String> _baseUrls = {
  EnvType.dev: 'https://dev-api.example.com',
  EnvType.staging: 'https://staging-api.example.com',
  EnvType.prod: 'https://api.example.com',
};
```

---

## 🔥 Firebase Setup

### Quick Setup

1. **Install FlutterFire CLI**
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. **Configure Firebase**
   ```bash
   flutterfire configure
   ```
   This will:
   - Create a Firebase project (or use existing)
   - Download config files
   - Generate `firebase_options.dart`

3. **That's it!** 🎉 Firebase services are ready to use.

### Available Services

| Service | Class | Purpose |
|---------|-------|---------|
| **Analytics** | `AnalyticsService` | Track events & screen views |
| **Crashlytics** | `CrashlyticsService` | Crash reporting |
| **Messaging** | `MessagingService` | Push notifications |
| **Remote Config** | `RemoteConfigService` | Feature flags |

### Usage Examples

```dart
// Analytics - Log custom event
AnalyticsService.logEvent(name: 'purchase', parameters: {'item': 'premium'});

// Crashlytics - Log error
CrashlyticsService.recordError(exception, stackTrace);

// Messaging - Get FCM token
final token = MessagingService.fcmToken;

// Remote Config - Get feature flag
final isNewUI = RemoteConfigService.getBool('feature_new_ui');
```

---

## 🏛️ Architecture

This boilerplate follows **Clean Architecture** principles:

```
┌─────────────────────────────────────────────────────┐
│                  Presentation Layer                  │
│         (UI, BLoC, Pages, Widgets)                  │
├─────────────────────────────────────────────────────┤
│                    Domain Layer                      │
│         (Entities, UseCases, Repositories)          │
├─────────────────────────────────────────────────────┤
│                     Data Layer                       │
│    (Models, DataSources, Repository Implementations) │
└─────────────────────────────────────────────────────┘
```

### Data Flow

```
UI → BLoC → UseCase → Repository → DataSource → API/Local Storage
```

---

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_bloc` | State management |
| `get_it` | Dependency injection |
| `go_router` | Navigation |
| `dio` | HTTP client |
| `shared_preferences` | Local storage |
| `dartz` | Functional programming (Either) |
| `equatable` | Value equality |
| `json_annotation` | JSON serialization |
| `intl` | Internationalization |

---

## 🛠️ Adding a New Feature

1. Create feature folder under `lib/features/your_feature/`
2. Add layers:
   - `data/` - DataSources, Models, Repositories
   - `domain/` - Entities, UseCases, Repository interfaces
   - `presentation/` - BLoC, Pages, Widgets
3. Register dependencies in `locator.dart`
4. Add routes in `router.dart`

---

## 📝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
