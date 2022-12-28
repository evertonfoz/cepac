import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBw45Y_3nvl16BiA7peS8jByaXIZlySl80",
            authDomain: "cepac-ccb5a.firebaseapp.com",
            projectId: "cepac-ccb5a",
            storageBucket: "cepac-ccb5a.appspot.com",
            messagingSenderId: "859317682922",
            appId: "1:859317682922:web:650d516170d7f6942a0d93",
            measurementId: "G-52LB43ZKY2"));
  } else {
    await Firebase.initializeApp();
  }
}
