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
    apiKey: 'AIzaSyCJqvPUDuEMWcGbf32JVlXayWyY_9va51U',
    appId: '1:1055730088459:web:58aaba8fc7da746d36250e',
    messagingSenderId: '1055730088459',
    projectId: 'ufin-4195c',
    authDomain: 'ufin-4195c.firebaseapp.com',
    storageBucket: 'ufin-4195c.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDThtSEwKg4tZm-WFMYfRsMYKU73wzvMoU',
    appId: '1:1055730088459:android:0a87cea9d842882236250e',
    messagingSenderId: '1055730088459',
    projectId: 'ufin-4195c',
    storageBucket: 'ufin-4195c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAI62F_edNS1LocP8mhc4oDy86Q_j4Ij0U',
    appId: '1:1055730088459:ios:b51999416c3bbc8a36250e',
    messagingSenderId: '1055730088459',
    projectId: 'ufin-4195c',
    storageBucket: 'ufin-4195c.appspot.com',
    iosClientId: '1055730088459-pb1fk2aglp0j24oljnuji96bun4v0431.apps.googleusercontent.com',
    iosBundleId: 'com.example.ufin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAI62F_edNS1LocP8mhc4oDy86Q_j4Ij0U',
    appId: '1:1055730088459:ios:905822d491d439a736250e',
    messagingSenderId: '1055730088459',
    projectId: 'ufin-4195c',
    storageBucket: 'ufin-4195c.appspot.com',
    iosClientId: '1055730088459-574eng69hp0atdq7dl1tp079q4hktql6.apps.googleusercontent.com',
    iosBundleId: 'com.example.ufin.RunnerTests',
  );
}
