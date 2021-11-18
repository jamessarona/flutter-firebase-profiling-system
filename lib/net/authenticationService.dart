import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> currentUser();
  Future<void> signOut();
}

class FireBaseAuth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    User? user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;

    return user!.uid;
  }

  Future<String> currentUser() async {
    User? user = _firebaseAuth.currentUser;
    return user!.uid;
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
