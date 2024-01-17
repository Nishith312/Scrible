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
    apiKey: 'AIzaSyA9IRPwa5FLwdR3H5zobel24OrXFWBfp7I',
    appId: '1:647190837112:web:227a8e92f4694bf7db3a8d',
    messagingSenderId: '647190837112',
    projectId: 'scribble-fc41d',
    authDomain: 'scribble-fc41d.firebaseapp.com',
    databaseURL: 'https://scribble-fc41d-default-rtdb.firebaseio.com',
    storageBucket: 'scribble-fc41d.appspot.com',
    measurementId: 'G-3R9M64CJFJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB15KgRaTsjQyecgmJLuhfFRD5f0EsZqE8',
    appId: '1:647190837112:android:e6770059e2462845db3a8d',
    messagingSenderId: '647190837112',
    projectId: 'scribble-fc41d',
    databaseURL: 'https://scribble-fc41d-default-rtdb.firebaseio.com',
    storageBucket: 'scribble-fc41d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB40PTKk9ZCu9FLjzbEhsGjzsrV3axKDU8',
    appId: '1:647190837112:ios:ba9fd55a50cd141ddb3a8d',
    messagingSenderId: '647190837112',
    projectId: 'scribble-fc41d',
    databaseURL: 'https://scribble-fc41d-default-rtdb.firebaseio.com',
    storageBucket: 'scribble-fc41d.appspot.com',
    iosBundleId: 'com.scriblenotes.scribleNotes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB40PTKk9ZCu9FLjzbEhsGjzsrV3axKDU8',
    appId: '1:647190837112:ios:9631558ff8fbe2b1db3a8d',
    messagingSenderId: '647190837112',
    projectId: 'scribble-fc41d',
    databaseURL: 'https://scribble-fc41d-default-rtdb.firebaseio.com',
    storageBucket: 'scribble-fc41d.appspot.com',
    iosBundleId: 'com.scriblenotes.scribleNotes.RunnerTests',
  );
}
