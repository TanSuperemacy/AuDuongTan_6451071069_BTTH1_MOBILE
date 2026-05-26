# Btth1 — Flutter Auth với Firebase & Clean Architecture

> **Ứng dụng Flutter** tích hợp Firebase Authentication + Firestore, tổ chức theo **Clean Architecture**.

---

## 📁 Cấu trúc thư mục (Clean Architecture)

```
lib/
├── main.dart                        # Entry point — khởi tạo Firebase & DI
├── firebase_options.dart            # Cấu hình Firebase (tạo bởi FlutterFire CLI)
│
├── core/
│   ├── di/
│   │   └── service_locator.dart     # GetIt — đăng ký tất cả dependency
│   ├── error/
│   │   ├── failures.dart            # Domain failures (AuthFailure, NetworkFailure…)
│   │   └── exceptions.dart          # Data exceptions (AuthException, NetworkException)
│   ├── constants/
│   │   ├── assets.dart
│   │   └── strings.dart
│   └── theme/
│       ├── app_colors.dart
│       ├── app_text_styles.dart
│       └── app_theme.dart
│
└── features/
    └── auth/
        ├── domain/                  # ① DOMAIN — Không phụ thuộc framework nào
        │   ├── entities/
        │   │   └── user_entity.dart
        │   ├── repositories/
        │   │   └── auth_repository.dart    # Abstract interface
        │   └── usecases/
        │       ├── login_usecase.dart
        │       ├── signup_usecase.dart
        │       └── forgot_password_usecase.dart
        │
        ├── data/                    # ② DATA — Triển khai repository & gọi Firebase
        │   ├── models/
        │   │   └── user_model.dart         # Extends UserEntity, serialize/deserialize
        │   ├── datasources/
        │   │   └── auth_remote_datasource.dart  # Gọi Firebase Auth + Firestore
        │   └── repositories/
        │       └── auth_repository_impl.dart    # Triển khai AuthRepository
        │
        └── presentation/            # ③ PRESENTATION — UI + BLoC
            ├── bloc/
            │   ├── auth_bloc.dart   # ChangeNotifier BLoC
            │   ├── auth_event.dart
            │   └── auth_state.dart
            └── pages/
                ├── logo_screen.dart
                ├── splash_screen.dart
                ├── login_screen.dart
                ├── signup_screen.dart
                ├── forgot_password_screen.dart
                ├── check_email_screen.dart
                └── successfully_screen.dart
```

### Nguyên tắc luồng dữ liệu

```
UI (Page)
  → AuthBloc.add(Event)
    → UseCase.call()
      → AuthRepository (abstract)
        → AuthRepositoryImpl
          → AuthRemoteDataSourceImpl (Firebase)
              ← UserModel
            ← Either<Failure, UserModel>
          ← Either<Failure, UserEntity>
        ← Either<Failure, UserEntity>
    ← State (AuthLoginSuccess / AuthFailure)
  ← rebuild UI
```

---

## 🔥 Hướng dẫn tạo & cấu hình Firebase

### Bước 1 — Tạo Firebase Project

1. Truy cập **[Firebase Console](https://console.firebase.google.com)**
2. Nhấn **"Add project"** (Thêm dự án)
3. Nhập tên project, ví dụ: `btth1-jobspot`
4. Bật / tắt Google Analytics tuỳ ý → **"Create project"**

---

### Bước 2 — Bật Authentication

1. Trong Firebase Console, chọn dự án → menu **Build → Authentication**
2. Nhấn **"Get started"**
3. Tab **"Sign-in method"** → bật **Email/Password** → **Save**

> **Lưu ý:** Chưa cần bật Google Sign-in ở bước này.

---

### Bước 3 — Tạo Firestore Database

1. Menu **Build → Firestore Database**
2. Nhấn **"Create database"**
3. Chọn **"Start in test mode"** (cho development) → chọn region gần nhất (ví dụ `asia-southeast1`)
4. Nhấn **"Done"**

> **⚠️ Test mode** cho phép đọc/ghi tự do trong 30 ngày. Nhớ cập nhật Rules trước khi production!

**Firestore Security Rules (production):**
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---

### Bước 4 — Thêm ứng dụng Android vào Firebase

1. Trang chủ project → nhấn icon **Android** (**`</>`**)
2. Nhập **Android package name**: mở file `android/app/build.gradle`, tìm dòng `applicationId`:
   ```groovy
   // android/app/build.gradle
   applicationId = "com.example.btth1"   // ← copy giá trị này
   ```
3. Đặt **App nickname** (tuỳ ý), bỏ qua SHA-1 key lúc đầu
4. Nhấn **"Register app"**
5. Tải file **`google-services.json`** → đặt vào `android/app/`

**Cập nhật `android/build.gradle` (project-level):**
```groovy
// android/build.gradle
buildscript {
  dependencies {
    classpath 'com.google.gms:google-services:4.4.2'   // thêm dòng này
  }
}
```

**Cập nhật `android/app/build.gradle` (app-level):**
```groovy
// android/app/build.gradle
apply plugin: 'com.google.gms.google-services'   // thêm ở cuối file
```

---

### Bước 5 — Cài FlutterFire CLI & sinh firebase_options.dart

> FlutterFire CLI tự động sinh file `lib/firebase_options.dart` chứa tất cả config. **Đây là cách được khuyến nghị nhất.**

```powershell
# 1. Cài FlutterFire CLI (chỉ cần làm 1 lần)
dart pub global activate flutterfire_cli

# 2. Đăng nhập Firebase (nếu chưa)
firebase login

# 3. Chạy trong thư mục project
cd c:\Users\HP\Documents\bttlmobile\btth1
flutterfire configure
```

CLI sẽ hỏi bạn chọn Firebase project và platform (Android/iOS/Web). Sau đó tự động:
- Sinh `lib/firebase_options.dart` với đúng API keys
- Cập nhật `android/app/google-services.json`
- Cập nhật `ios/Runner/GoogleService-Info.plist`

> **File placeholder hiện tại** (`lib/firebase_options.dart`) sẽ bị overwrite — đó là điều cần làm!

---

### Bước 6 — Cài dependencies

```powershell
flutter pub get
```

---

### Bước 7 — Chạy ứng dụng

```powershell
flutter run
```

---

## 📦 Các package đã dùng

| Package | Phiên bản | Mục đích |
|---|---|---|
| `firebase_core` | ^3.13.1 | Khởi tạo Firebase |
| `firebase_auth` | ^5.5.4 | Đăng ký / đăng nhập |
| `cloud_firestore` | ^5.6.9 | Lưu profile user |
| `get_it` | ^8.0.3 | Dependency injection |
| `dartz` | ^0.10.1 | `Either<Failure, T>` — functional error handling |
| `flutter_bloc` | ^9.1.1 | Provider / ChangeNotifier utilities |

---

## 🏗️ Kiến trúc chi tiết

### 1. Domain Layer (`domain/`)

**Không phụ thuộc vào bất kỳ package nào ngoài Dart thuần và `dartz`.**

- **`UserEntity`** — Plain Dart object, chứa `id`, `fullName`, `email`
- **`AuthRepository`** *(abstract)* — Contract xác định những gì Data layer phải làm
- **`LoginUseCase`**, **`SignUpUseCase`**, **`ForgotPasswordUseCase`** — Business logic đơn giản, inject `AuthRepository`

### 2. Data Layer (`data/`)

- **`UserModel`** — Extends `UserEntity`, có `fromMap()` / `toMap()` cho Firestore
- **`AuthRemoteDataSourceImpl`** — Gọi Firebase Auth:
  - `signInWithEmailAndPassword()` → đăng nhập
  - `createUserWithEmailAndPassword()` → đăng ký, rồi lưu thêm vào Firestore collection `users/`
  - `sendPasswordResetEmail()` → quên mật khẩu
- **`AuthRepositoryImpl`** — Bắt `AuthException` từ datasource, map thành `Failure` và trả `Either<Failure, T>`

### 3. Presentation Layer (`presentation/`)

- **`AuthBloc`** *(ChangeNotifier)* — Nhận events, gọi use cases, emit states
- **`LoginScreen`** / **`SignUpScreen`** — Dùng `ListenableBuilder` để rebuild khi BLoC thay đổi; xử lý `AuthLoginSuccess` → navigate, `AuthFailure` → SnackBar

### 4. Dependency Injection (`core/di/service_locator.dart`)

```
GetIt (sl)
  Firebase.instance     → Singleton
  AuthRemoteDataSource  → LazySingleton
  AuthRepository        → LazySingleton  
  LoginUseCase          → LazySingleton
  SignUpUseCase         → LazySingleton
  ForgotPasswordUseCase → LazySingleton
  AuthBloc              → Factory (mới mỗi lần)
```

---

## 🛠️ Xử lý lỗi Firebase (tiếng Việt)

| Firebase Error Code | Thông báo hiển thị |
|---|---|
| `user-not-found` | Không tìm thấy tài khoản với email này |
| `wrong-password` | Mật khẩu không đúng. Vui lòng thử lại |
| `email-already-in-use` | Email này đã được sử dụng. Vui lòng đăng nhập |
| `invalid-email` | Địa chỉ email không hợp lệ |
| `weak-password` | Mật khẩu quá yếu. Cần ít nhất 6 ký tự |
| `too-many-requests` | Quá nhiều lần thử. Vui lòng đợi rồi thử lại |
| `network-request-failed` | Lỗi kết nối mạng. Vui lòng kiểm tra internet |
| `invalid-credential` | Email hoặc mật khẩu không chính xác |

---

## ✅ Checklist trước khi chạy

- [ ] Đã tạo Firebase project
- [ ] Đã bật **Email/Password** trong Authentication
- [ ] Đã tạo **Firestore Database** (test mode)
- [ ] Đã chạy `flutterfire configure` → sinh `firebase_options.dart` thực
- [ ] Đã đặt `google-services.json` vào `android/app/`
- [ ] Đã cập nhật cả hai file `build.gradle`
- [ ] Đã chạy `flutter pub get`

---

## 🔐 Cấu trúc Firestore

Collection: **`users`**

| Field | Type | Mô tả |
|---|---|---|
| `fullName` | String | Tên đầy đủ |
| `email` | String | Địa chỉ email |
| `createdAt` | String | ISO 8601 timestamp |

Document ID = Firebase Auth UID của user.
