import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> signUpWithEmailAndPassword(String email, String password);
  Future<String> registerWithEmailPasswordAdmin(String email, String password);
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

  Future<String> signUpWithEmailAndPassword(
      String email, String password) async {
    User? user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;

    return user!.uid;
  }

  Future<String> registerWithEmailPasswordAdmin(
      String email, String password) async {
    try {
      FirebaseApp tempApp = await Firebase.initializeApp(
          name: DateTime.now().millisecondsSinceEpoch.toString(),
          options: Firebase.app().options);

      UserCredential result = await FirebaseAuth.instanceFor(app: tempApp)
          .createUserWithEmailAndPassword(email: email, password: password);

      tempApp.delete();
      return result.user!.uid;
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  Future<String> currentUser() async {
    User? user = _firebaseAuth.currentUser;

    return user!.uid;
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
