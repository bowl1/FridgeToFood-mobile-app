// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyByPKZjOgwbVRF0vJqDdlYwJsSsyok0gSU',
    appId: '1:605774693006:web:32c2bb4cf8c44e7130ffdf',
    messagingSenderId: '605774693006',
    projectId: 'recipe-8fbff',
    authDomain: 'recipe-8fbff.firebaseapp.com',
    storageBucket: 'recipe-8fbff.firebasestorage.app',
    measurementId: 'G-BG9KZXYSHJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAcD5vIhcZOR_CPsM3d3vkwrZ5teiZd7xE',
    appId: '1:605774693006:android:b522a55bd52492ff30ffdf',
    messagingSenderId: '605774693006',
    projectId: 'recipe-8fbff',
    storageBucket: 'recipe-8fbff.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDEceJRoMomclx9vkiA6PgH80TbU8oJEBQ',
    appId: '1:605774693006:ios:17a465a82c14c90530ffdf',
    messagingSenderId: '605774693006',
    projectId: 'recipe-8fbff',
    storageBucket: 'recipe-8fbff.firebasestorage.app',
    iosBundleId: 'com.example.learning',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDEceJRoMomclx9vkiA6PgH80TbU8oJEBQ',
    appId: '1:605774693006:ios:17a465a82c14c90530ffdf',
    messagingSenderId: '605774693006',
    projectId: 'recipe-8fbff',
    storageBucket: 'recipe-8fbff.firebasestorage.app',
    iosBundleId: 'com.example.learning',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyByPKZjOgwbVRF0vJqDdlYwJsSsyok0gSU',
    appId: '1:605774693006:web:20bf2abd561f4ae430ffdf',
    messagingSenderId: '605774693006',
    projectId: 'recipe-8fbff',
    authDomain: 'recipe-8fbff.firebaseapp.com',
    storageBucket: 'recipe-8fbff.firebasestorage.app',
    measurementId: 'G-KM7WB4T60S',
  );
}
