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
    apiKey: 'AIzaSyC6j1TgsNTfMIO5c88wD_LIpNQEc1MvKHo',
    appId: '1:644373985610:web:a67a41e4da49576b0829b3',
    messagingSenderId: '644373985610',
    projectId: 'flutter-9c9d6',
    authDomain: 'flutter-9c9d6.firebaseapp.com',
    storageBucket: 'flutter-9c9d6.appspot.com',
    measurementId: 'G-W5NXZMQDGV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDdqkwIDi3EiaV5Sw77CE1AqG0l6iw0hZo',
    appId: '1:644373985610:android:0dcd718ebcdad7050829b3',
    messagingSenderId: '644373985610',
    projectId: 'flutter-9c9d6',
    storageBucket: 'flutter-9c9d6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDCpMCjgvVFBneYZlCQKDmahOsHiDSgC9I',
    appId: '1:644373985610:ios:ccc3d21b3175757f0829b3',
    messagingSenderId: '644373985610',
    projectId: 'flutter-9c9d6',
    storageBucket: 'flutter-9c9d6.appspot.com',
    iosClientId: '644373985610-5vukj27dl3rpcfj1v6lenq00kd3e2hio.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterFirebase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDCpMCjgvVFBneYZlCQKDmahOsHiDSgC9I',
    appId: '1:644373985610:ios:ccc3d21b3175757f0829b3',
    messagingSenderId: '644373985610',
    projectId: 'flutter-9c9d6',
    storageBucket: 'flutter-9c9d6.appspot.com',
    iosClientId: '644373985610-5vukj27dl3rpcfj1v6lenq00kd3e2hio.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterFirebase',
  );
}
