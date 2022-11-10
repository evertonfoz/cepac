import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class CepacFirebaseUser {
  CepacFirebaseUser(this.user);
  User? user;
  bool get loggedIn => user != null;
}

CepacFirebaseUser? currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<CepacFirebaseUser> cepacFirebaseUserStream() => FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<CepacFirebaseUser>(
      (user) {
        currentUser = CepacFirebaseUser(user);
        return currentUser!;
      },
    );
