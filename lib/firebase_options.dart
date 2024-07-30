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
    apiKey: 'AIzaSyCiWM-_JDY9FvXs5ymlhrkhIfMhYwCv9aU',
    appId: '1:163023546495:web:434dc4c309f13ab361b74a',
    messagingSenderId: '163023546495',
    projectId: 'prayer-jamat-timings',
    authDomain: 'prayer-jamat-timings.firebaseapp.com',
    storageBucket: 'prayer-jamat-timings.appspot.com',
    measurementId: 'G-KV999JEJ4G',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBgTPY2d0chjzfOxeQTuxmsIBlN_Iy-Vd4',
    appId: '1:163023546495:android:22eb25bbfb97cc3061b74a',
    messagingSenderId: '163023546495',
    projectId: 'prayer-jamat-timings',
    storageBucket: 'prayer-jamat-timings.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCMJGOsTKYghAww39SKMJuVJ5WvNquONjA',
    appId: '1:163023546495:ios:e56f743452009bd461b74a',
    messagingSenderId: '163023546495',
    projectId: 'prayer-jamat-timings',
    storageBucket: 'prayer-jamat-timings.appspot.com',
    iosBundleId: 'com.example.prayerJamatTimings',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCMJGOsTKYghAww39SKMJuVJ5WvNquONjA',
    appId: '1:163023546495:ios:e56f743452009bd461b74a',
    messagingSenderId: '163023546495',
    projectId: 'prayer-jamat-timings',
    storageBucket: 'prayer-jamat-timings.appspot.com',
    iosBundleId: 'com.example.prayerJamatTimings',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCiWM-_JDY9FvXs5ymlhrkhIfMhYwCv9aU',
    appId: '1:163023546495:web:daa913b432b3584161b74a',
    messagingSenderId: '163023546495',
    projectId: 'prayer-jamat-timings',
    authDomain: 'prayer-jamat-timings.firebaseapp.com',
    storageBucket: 'prayer-jamat-timings.appspot.com',
    measurementId: 'G-TR2EKL2L22',
  );
}