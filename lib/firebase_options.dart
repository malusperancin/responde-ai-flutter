import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart';


class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    } else {
      throw UnsupportedError(
        'DefaultFirebaseOptions are not supported for this platform.',
      );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyBeE6bCuBi3-ABicndiSYbBo3q92I1ZZCg",
    authDomain: "responde-ai-si700.firebaseapp.com",
    projectId: "responde-ai-si700",
    storageBucket: "responde-ai-si700.firebasestorage.app",
    messagingSenderId: "563112049979",
    appId: "1:563112049979:web:5b8908db381cc0ff908b1e",
    measurementId: "G-K0QC8VHPHJ"
  );
}