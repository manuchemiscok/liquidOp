// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyB98WcwZ4zo1r2HfWfjcLIH9rRvySxHtH8',
    appId: '1:9059441475:web:a4124ada1f09640f96edf6',
    messagingSenderId: '9059441475',
    projectId: 'liquidoperator-7702e',
    authDomain: 'liquidoperator-7702e.firebaseapp.com',
    storageBucket: 'liquidoperator-7702e.appspot.com',
    measurementId: 'G-SQMP0S6JPK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCpfagsOqCE0q87aZPOa1yf6K8T-vS9KAc',
    appId: '1:9059441475:android:fd3988b99321e4bc96edf6',
    messagingSenderId: '9059441475',
    projectId: 'liquidoperator-7702e',
    storageBucket: 'liquidoperator-7702e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAhzazxxh8U0eXjA9apdsAZUqNPj0Y7DPw',
    appId: '1:9059441475:ios:56f4cd7440f625f896edf6',
    messagingSenderId: '9059441475',
    projectId: 'liquidoperator-7702e',
    storageBucket: 'liquidoperator-7702e.appspot.com',
    iosBundleId: 'com.example.liquidop',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAhzazxxh8U0eXjA9apdsAZUqNPj0Y7DPw',
    appId: '1:9059441475:ios:0555dcf3b894b7f896edf6',
    messagingSenderId: '9059441475',
    projectId: 'liquidoperator-7702e',
    storageBucket: 'liquidoperator-7702e.appspot.com',
    iosBundleId: 'com.example.liquidop.RunnerTests',
  );
}
