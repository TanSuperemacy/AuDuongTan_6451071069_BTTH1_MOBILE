// File này được tự động tạo bởi FlutterFire CLI.
// Chạy lệnh: flutterfire configure
// để sinh ra nội dung thực từ Firebase project của bạn.
//
// ⚠️  ĐÂY LÀ FILE PLACEHOLDER — PHẢI CHẠY flutterfire configure TRƯỚC KHI BUILD!
//
// Xem hướng dẫn chi tiết trong README.md

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Cấu hình Firebase mặc định cho mỗi platform.
/// Sinh tự động bởi: flutterfire configure
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions chưa được cấu hình cho platform này.',
        );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // THAY THẾ CÁC GIÁ TRỊ BÊN DƯỚI BẰNG CỦA FIREBASE PROJECT CỦA BẠN
  // hoặc chạy: flutterfire configure  (được khuyến nghị hơn)
  // ─────────────────────────────────────────────────────────────────────────

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDkGd5Je7JQKzEhikiJPxy9Wl3fzCbeVyw',
    appId: '1:199819640598:web:cc16661f40b1860005da37',
    messagingSenderId: '199819640598',
    projectId: 'btth1-jobspot',
    authDomain: 'btth1-jobspot.firebaseapp.com',
    storageBucket: 'btth1-jobspot.firebasestorage.app',
    measurementId: 'G-PHJ0KNC0WN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCDFsrlIS6EJeRKs9AerA5vJH2yWJQqAuM',
    appId: '1:199819640598:android:84987d868b63819b05da37',
    messagingSenderId: '199819640598',
    projectId: 'btth1-jobspot',
    storageBucket: 'btth1-jobspot.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCpMYJfZ2abIHH9GkvIK4UOyKsx2bap_BE',
    appId: '1:199819640598:ios:ed67e8daf8d87e0105da37',
    messagingSenderId: '199819640598',
    projectId: 'btth1-jobspot',
    storageBucket: 'btth1-jobspot.firebasestorage.app',
    iosBundleId: 'com.example.btth1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCpMYJfZ2abIHH9GkvIK4UOyKsx2bap_BE',
    appId: '1:199819640598:ios:ed67e8daf8d87e0105da37',
    messagingSenderId: '199819640598',
    projectId: 'btth1-jobspot',
    storageBucket: 'btth1-jobspot.firebasestorage.app',
    iosBundleId: 'com.example.btth1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDkGd5Je7JQKzEhikiJPxy9Wl3fzCbeVyw',
    appId: '1:199819640598:web:bb8b970a062365db05da37',
    messagingSenderId: '199819640598',
    projectId: 'btth1-jobspot',
    authDomain: 'btth1-jobspot.firebaseapp.com',
    storageBucket: 'btth1-jobspot.firebasestorage.app',
    measurementId: 'G-PGNTDLHWEQ',
  );

}