# Flutter Boilerplate

<p align="center">
  <img src="https://flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup.png" alt="Flutter Logo" width="300"/>
</p>

<p align="center">
  <strong>Boilerplate Flutter siap produksi dengan Clean Architecture, BLoC Pattern, dan best practices.</strong>
</p>

<p align="center">
  <a href="README.md">🇬🇧 English</a>
</p>

---

## ✨ Fitur

- 🏗️ **Clean Architecture** - Pemisahan concerns dengan layer Data, Domain, dan Presentation
- 📦 **BLoC Pattern** - State management yang predictable
- 🌍 **Multi-Environment** - Flavor Dev, Staging, Production untuk Android & iOS
- 🌐 **Lokalisasi** - Siap untuk multi bahasa (English & Indonesia tersedia)
- 🎨 **Ganti Tema** - Tema Light, Dark, dan System
- 💉 **Dependency Injection** - Menggunakan GetIt sebagai service locator
- 🔄 **Dio HTTP Client** - Dengan retry interceptor dan logging
- 💾 **Penyimpanan Lokal** - Implementasi SharedPreferences
- 🛣️ **GoRouter** - Routing deklaratif
- 🔥 **Firebase Siap** - Analytics, Crashlytics, Push Notifications, Remote Config

---

## 📁 Struktur Project

```
lib/
├── app.dart                    # Widget aplikasi root
├── main.dart                   # Entry point
├── locator.dart                # Setup dependency injection
├── router.dart                 # Konfigurasi route
├── core/                       # Utilitas inti & kode bersama
│   ├── common/                 # Entitas bersama
│   ├── config/                 # Konfigurasi app (DioClient, Environment)
│   ├── constants/              # Konstanta app
│   ├── error/                  # Class Failure
│   ├── services/               # Layanan inti
│   ├── themes/                 # Tema app
│   ├── usecases/               # Base UseCase class
│   ├── utils/                  # Utilitas & extensions
│   └── widgets/                # Widget reusable
├── features/                   # Modul fitur
│   └── settings/               # Fitur Settings
│       ├── data/               # Data layer
│       │   ├── datasources/    # Local/Remote data sources
│       │   ├── models/         # Model data
│       │   └── repositories/   # Implementasi repository
│       ├── domain/             # Domain layer
│       │   ├── entities/       # Entitas bisnis
│       │   ├── repositories/   # Interface repository
│       │   └── usecases/       # Use cases
│       └── presentation/       # Presentation layer
│           ├── bloc/           # BLoC state management
│           ├── pages/          # Widget halaman
│           └── widgets/        # Widget khusus fitur
└── l10n/                       # File lokalisasi
    ├── app_en.arb              # Terjemahan Inggris
    └── app_id.arb              # Terjemahan Indonesia
```

---

## 🚀 Memulai

### Prasyarat

- Flutter SDK 3.5.0 atau lebih tinggi
- Dart SDK 3.5.0 atau lebih tinggi
- Android Studio / VS Code
- Xcode (untuk pengembangan iOS)

### Instalasi

1. **Clone repository**
   ```bash
   git clone https://github.com/your-username/flutter-boilerplate.git
   cd flutter-boilerplate
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate file lokalisasi**
   ```bash
   flutter gen-l10n
   ```

4. **Generate kode (JSON serialization)**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Jalankan aplikasi**
   ```bash
   flutter run --flavor dev
   ```

---

## 🏃 Menjalankan Aplikasi

### Dengan Flavor (Direkomendasikan)

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

## 🌍 Konfigurasi Environment

Aplikasi mendukung beberapa environment dengan endpoint API berbeda:

| Environment | API URL | Suffix Bundle ID |
|-------------|---------|------------------|
| Development | `https://dev-api.example.com` | `.dev` |
| Staging | `https://staging-api.example.com` | `.staging` |
| Production | `https://api.example.com` | (tidak ada) |

Konfigurasi URL di `lib/core/config/app_env.dart`:

```dart
static const Map<EnvType, String> _baseUrls = {
  EnvType.dev: 'https://dev-api.example.com',
  EnvType.staging: 'https://staging-api.example.com',
  EnvType.prod: 'https://api.example.com',
};
```

---

## 🔥 Setup Firebase

### Setup Cepat

1. **Install FlutterFire CLI**
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. **Konfigurasi Firebase**
   ```bash
   flutterfire configure
   ```
   Ini akan:
   - Membuat project Firebase (atau pakai yang sudah ada)
   - Download file konfigurasi
   - Generate `firebase_options.dart`

3. **Selesai!** 🎉 Firebase services siap dipakai.

### Services yang Tersedia

| Service | Class | Kegunaan |
|---------|-------|----------|
| **Analytics** | `AnalyticsService` | Track events & screen views |
| **Crashlytics** | `CrashlyticsService` | Crash reporting |
| **Messaging** | `MessagingService` | Push notifications |
| **Remote Config** | `RemoteConfigService` | Feature flags |

### Contoh Penggunaan

```dart
// Analytics - Log custom event
AnalyticsService.logEvent(name: 'purchase', parameters: {'item': 'premium'});

// Crashlytics - Log error
CrashlyticsService.recordError(exception, stackTrace);

// Messaging - Ambil FCM token
final token = MessagingService.fcmToken;

// Remote Config - Ambil feature flag
final isNewUI = RemoteConfigService.getBool('feature_new_ui');
```

---

## 🏛️ Arsitektur

Boilerplate ini mengikuti prinsip **Clean Architecture**:

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

### Alur Data

```
UI → BLoC → UseCase → Repository → DataSource → API/Penyimpanan Lokal
```

---

## 📦 Dependencies

| Package | Kegunaan |
|---------|----------|
| `flutter_bloc` | State management |
| `get_it` | Dependency injection |
| `go_router` | Navigasi |
| `dio` | HTTP client |
| `shared_preferences` | Penyimpanan lokal |
| `dartz` | Pemrograman fungsional (Either) |
| `equatable` | Persamaan nilai |
| `json_annotation` | Serialisasi JSON |
| `intl` | Internasionalisasi |

---

## 🛠️ Menambahkan Fitur Baru

1. Buat folder fitur di `lib/features/fitur_anda/`
2. Tambahkan layer:
   - `data/` - DataSources, Models, Repositories
   - `domain/` - Entities, UseCases, Interface Repository
   - `presentation/` - BLoC, Pages, Widgets
3. Daftarkan dependencies di `locator.dart`
4. Tambahkan route di `router.dart`

---

## 📝 Kontribusi

1. Fork repository
2. Buat branch fitur (`git checkout -b feature/fitur-keren`)
3. Commit perubahan (`git commit -m 'Menambahkan fitur keren'`)
4. Push ke branch (`git push origin feature/fitur-keren`)
5. Buka Pull Request

---

## 📄 Lisensi

Project ini dilisensikan di bawah MIT License - lihat file [LICENSE](LICENSE) untuk detail.
