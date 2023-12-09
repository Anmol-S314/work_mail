import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService extends ChangeNotifier {
  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth?.accessToken,
      idToken: gAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance
        .login(permissions: ['email', 'public_profile']);
    final OAuthCredential facebookAuthcredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    // var userData = await FacebookAuth.instance.getUserData();
    return await FirebaseAuth.instance
        .signInWithCredential(facebookAuthcredential);
  }

  // signInWithPhone() {
    // final code = otpCodeController.text.trim();
    // AuthCredential authcredential = PhoneAuthProvider.credential(
    //     verificationId: verificationId,
    //      smsCode: smsCode);
    //      return await FirebaseAuth.instance
    //     .signInWithCredential(authcredential);

  // }
}
