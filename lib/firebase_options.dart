import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
          'DefaultFirebaseOptions have not been configured for Linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDgWktiuoVQSRvNyvpaW3cp4mLaqG4v3r4',
    appId: '1:295118432688:web:c94fe6f7db09cc9fecce75',
    messagingSenderId: '295118432688',
    projectId: 'the-deaf-world',
    authDomain: 'the-deaf-world.firebaseapp.com',
    storageBucket: 'the-deaf-world.appspot.com',
    measurementId: 'WEB_MEASUREMENT_ID',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'ANDROID_API_KEY',
    appId: 'ANDROID_APP_ID',
    messagingSenderId: 'ANDROID_MESSAGING_SENDER_ID',
    projectId: 'the-deaf-world',
    storageBucket: 'the-deaf-world.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'IOS_API_KEY',
    appId: 'IOS_APP_ID',
    messagingSenderId: 'IOS_MESSAGING_SENDER_ID',
    projectId: 'the-deaf-world',
    storageBucket: 'the-deaf-world.appspot.com',
    iosBundleId: 'com.example.cyApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'IOS_API_KEY',
    appId: 'IOS_APP_ID',
    messagingSenderId: 'IOS_MESSAGING_SENDER_ID',
    projectId: 'the-deaf-world',
    storageBucket: 'the-deaf-world.appspot.com',
    iosBundleId: 'com.example.cyApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'WEB_API_KEY',
    appId: 'WEB_APP_ID',
    messagingSenderId: 'WEB_MESSAGING_SENDER_ID',
    projectId: 'the-deaf-world',
    authDomain: 'the-deaf-world.firebaseapp.com',
    storageBucket: 'the-deaf-world.appspot.com',
    measurementId: 'WEB_MEASUREMENT_ID',
  );
}