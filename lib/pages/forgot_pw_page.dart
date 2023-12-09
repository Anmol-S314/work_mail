import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:work_mail/components/my_button.dart';
import 'package:work_mail/components/my_textfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void wEmailMessage(String message) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Oops! Try Again"),
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

    void yEmailMessage(String message) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Congrats!"),
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

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
          yEmailMessage('Password Reset Link sent to your Email');
    } on FirebaseAuthException catch (e) {
      print(e);
      wEmailMessage(e.message.toString());
      // showDialog(
      //     context: context,
      //     builder: (context) {
      //       return AlertDialog(
      //         content: Text(e.message.toString()),
      //       );
      //     });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 246, 246),
      appBar: AppBar(backgroundColor: Color.fromARGB(255, 246, 246, 246)),
      body: Column(
        
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '    Enter Email',
                  style: TextStyle(
                    color: Colors.grey[700],
                    // fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),

          const SizedBox(height: 12),

          //email textfield
          MyTextField(
            controller: emailController,
            hintText: 'abc@email.com',
            obscureText: false,
          ),

          const SizedBox(height: 12),

          // Reset pwd button
              MyButton(
                text: 'Reset Password',
                onTap: passwordReset,
              ),

          // MaterialButton(
          //   onPressed: passwordReset,
          //   child: Text("Reset Password"),
          //   color: Colors.deepPurple[200],
          // )
         const SizedBox(height:150),

        ],
        
      ),
      
    );
  }
}
