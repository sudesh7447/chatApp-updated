

import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/widgets.dart';
import 'database_services.dart';

class AuthServices {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Login
  Future LoginUserwithEmailandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message;
    }
  }

  // Register
  Future registerUserwithEmailandPassword(
      String FullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        // call database service to update the data
        await DatabaseService(uid: user.uid).saveUserData(FullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message;
    }
  }

  // Log Out

  Future SignOut() async {
    try {
      await HelperFunctions.SaveUSerLoggedInStatus(false);
      await HelperFunctions.SaveUserEmailSF("");
      await HelperFunctions.SaveUserNameSF("");
      await FirebaseAuth.instance.signOut();
      // nextScreenReplace(context, LoginPage());
    } catch (e) {
      return null;
    }
  }
}
