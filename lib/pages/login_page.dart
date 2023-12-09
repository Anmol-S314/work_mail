//import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:work_mail/components/my_button.dart';
import 'package:work_mail/components/my_textfield.dart';
import 'package:work_mail/components/square_tile.dart';
import 'package:work_mail/pages/forgot_pw_page.dart';
import 'package:work_mail/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // wrong email message popup
  void wrongEmailMessage(String message) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Oops! Try Again"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (context) {
        return alert;

        // backgroundColor: Colors.deepPurple,
        // title: Center(
        //   child: Text(
        //     message,
        //     style: const TextStyle(color: Colors.white),
        //   ),
      },
    );
  }

  // sign user in method
  void signUserIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try sign in
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'uid': userCredential.user!.uid,
        'email': userCredential.user!.email,
      }, SetOptions(merge: true));
      // pop the loading circle
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.of(context).pop();
      // WRONG EMAIL
      // final ex = TExceptions.fromCode(e.code);
      // if (e.code == 'user-not-found') {
      // show error to user

      wrongEmailMessage(e.message.toString());

      // // WRONG PASSWORD
      // else if (e.code == 'wrong-password') {
      //   // show error to user
      //   print('bruh');
      //   wrongEmailMessage(e.message.toString());
      // }
    }
  }

  // // wrong password message popup
  // void wrongPasswordMessage(String message) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         backgroundColor: Colors.deepPurple,
  //         title: Center(
  //           child: Text(
  //             message,
  //             style: const TextStyle(color: Colors.white),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 246, 246, 246),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("lib/images/login2.png"),
                    fit: BoxFit.fill)),
          ),
          SingleChildScrollView(
            child: Container(
              //  decoration: const BoxDecoration(
              //   // Image set to background of the body
              //   image: DecorationImage(
              //       image: AssetImage('lib/images/mail-icon3.png'),
              //        fit: BoxFit.fitHeight,
              //        opacity:0.1),),

              constraints: const BoxConstraints(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 75),

                  // logo
                  // const Icon(
                  //   Icons.mail_lock,
                  //   size: 75,
                  // ),
                  Image.asset("lib/images/email.png",height:200,width:200),

                  const SizedBox(height: 12),

                  // welcome back, you've been missed!
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '    Login',
                      style: TextStyle(
                        color: Colors.grey[800],
                        // fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  const SizedBox(height: 15),

                  //email textfield
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 12),

                  // password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 12),

                  // forgot password?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const ForgotPasswordPage();
                                },
                              ),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.blue,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // sign in button
                  MyButton(
                    text: 'Sign In',
                    onTap: signUserIn,
                  ),

                  const SizedBox(height: 25),

                  // or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.3,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // google + apple sign in buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // google button
                      SquareTile(
                          onTap: () => {AuthService().signInWithGoogle()},
                          label: 'Continue with Google',
                          imagePath: 'lib/images/google.png'),

                      SizedBox(width: 20),

                      // facebook button
                      SquareTile(
                          onTap: () => {AuthService().signInWithFacebook()},
                          label: 'Continue with Facebook',
                          imagePath: 'lib/images/facebook.png'),

                      // SizedBox(width: 20),

                      // // apple button
                      // SquareTile(
                      //     onTap: () => {}, imagePath: 'lib/images/twitter.png'),
                      // SizedBox(width: 20),

                      // // phone button

                      // SquareTile(
                      //     onTap: () => {
                      //           Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (context) {
                      //                 return const PhoneLoginPage();
                      //               },
                      //             ),
                      //           )
                      //         },
                      //     imagePath: 'lib/images/phone.png')
                    ],
                  ),

                  const SizedBox(height: 25),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Register now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // const
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
