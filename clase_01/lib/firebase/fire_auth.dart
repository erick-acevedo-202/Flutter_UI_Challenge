import 'package:firebase_auth/firebase_auth.dart';

class FireAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> registerUser(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      user!
          .sendEmailVerification(); //user.isVerified para saber si ya fue verificado
      return user;
    } catch (e) {
      print('Error during Register: ${e.toString()}');
      return null;
    }
  }

  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      if (user != null && !user.emailVerified) {
        await _auth.signOut();
        throw FirebaseAuthException(
            code: "email-not-verified",
            message: "Por favor verifique su correo electrónico");
      }
      return user;
    } catch (e) {
      print(e.toString());
    }
  }
}
