import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  static FirebaseOptions get android => FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY'] ?? 'your-api-key',
        appId: dotenv.env['FIREBASE_APP_ID'] ?? 'your-app-id',
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? 'your-sender-id',
        projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'gyan-ai-app',
        storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'gyan-ai-app.appspot.com',
      );

  static FirebaseOptions get ios => FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY'] ?? 'your-api-key',
        appId: dotenv.env['FIREBASE_APP_ID'] ?? 'your-app-id',
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? 'your-sender-id',
        projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'gyan-ai-app',
        storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'gyan-ai-app.appspot.com',
        iosClientId: dotenv.env['FIREBASE_IOS_CLIENT_ID'],
        iosBundleId: 'com.gyanai.app',
      );

  static FirebaseOptions get web => FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY'] ?? 'your-api-key',
        appId: dotenv.env['FIREBASE_APP_ID'] ?? 'your-app-id',
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? 'your-sender-id',
        projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'gyan-ai-app',
        storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'gyan-ai-app.appspot.com',
      );
}
