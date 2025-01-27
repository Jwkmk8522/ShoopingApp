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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDIYcLCl3qQnL8Vq6ChNApk3Zy1QYRbbME',
    appId: '1:402647760779:web:9beaa5e74a545435d0b98e',
    messagingSenderId: '402647760779',
    projectId: 'shoopingapp-12774',
    authDomain: 'shoopingapp-12774.firebaseapp.com',
    storageBucket: 'shoopingapp-12774.firebasestorage.app',
    measurementId: 'G-TL0HLB3Y59',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBux1Z-5luWmtBIe8A2DA2HG7yT4eJi-ZQ',
    appId: '1:402647760779:android:b1b3d127cbda9989d0b98e',
    messagingSenderId: '402647760779',
    projectId: 'shoopingapp-12774',
    storageBucket: 'shoopingapp-12774.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAxO4hKLUl4hucbKAD4qkPmhvcPcpa5p34',
    appId: '1:402647760779:ios:0e0bfb879b2e5ffad0b98e',
    messagingSenderId: '402647760779',
    projectId: 'shoopingapp-12774',
    storageBucket: 'shoopingapp-12774.firebasestorage.app',
    iosBundleId: 'com.example.shoopingApp',
  );
}