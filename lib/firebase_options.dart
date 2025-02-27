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
    apiKey: 'AIzaSyDgWktiuoVQSRvNyvpaW3cp4mLaqG4v3r4',
    appId: '1:295118432688:web:c94fe6f7db09cc9fecce75',
    messagingSenderId: '295118432688',
    projectId: 'the-deaf-world',
    authDomain: 'the-deaf-world.firebaseapp.com',
    storageBucket: 'the-deaf-world.firebasestorage.app',
    measurementId: 'G-WTL09QV1CG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD4AGea8e9oU5UZB6rb2aw1Pbnq7iWSSzg',
    appId: '1:295118432688:android:5b5d39c1896e0a0fecce75',
    messagingSenderId: '295118432688',
    projectId: 'the-deaf-world',
    storageBucket: 'the-deaf-world.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDD5gKHEWmW3ce-pVei7gSTuvwD21mxWes',
    appId: '1:295118432688:ios:5e0503b6db388a37ecce75',
    messagingSenderId: '295118432688',
    projectId: 'the-deaf-world',
    storageBucket: 'the-deaf-world.firebasestorage.app',
    iosBundleId: 'com.example.cyApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDD5gKHEWmW3ce-pVei7gSTuvwD21mxWes',
    appId: '1:295118432688:ios:5e0503b6db388a37ecce75',
    messagingSenderId: '295118432688',
    projectId: 'the-deaf-world',
    storageBucket: 'the-deaf-world.firebasestorage.app',
    iosBundleId: 'com.example.cyApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDgWktiuoVQSRvNyvpaW3cp4mLaqG4v3r4',
    appId: '1:295118432688:web:15623b35595ab3deecce75',
    messagingSenderId: '295118432688',
    projectId: 'the-deaf-world',
    authDomain: 'the-deaf-world.firebaseapp.com',
    storageBucket: 'the-deaf-world.firebasestorage.app',
    measurementId: 'G-QX0NT1F09J',
  );

}