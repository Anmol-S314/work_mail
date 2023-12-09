import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:work_mail/components/my_button.dart';
import 'package:work_mail/components/my_textfield.dart';
import 'package:work_mail/components/square_tile.dart';
import 'package:work_mail/pages/home_page.dart';
import 'package:work_mail/pages/intro_pages/contacts_page.dart';
import 'package:work_mail/services/auth_service.dart';
import 'package:work_mail/services/chat/chat_service.dart';

class SendEmailPage extends StatefulWidget {
  // final Function()? onTap;
  const SendEmailPage({super.key});

  @override
  State<SendEmailPage> createState() => _SendEmailPageState();
}

class _SendEmailPageState extends State<SendEmailPage> {
  // text editing controllers
  // final fromController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  final ChatService _chatService = ChatService();
  final toController = TextEditingController();
  final messageController = TextEditingController();

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
      },
    );
  }

  // sign user up method
  void sendEmail(String receiverUserEmail) async {
    // show loading circle

    // //check is password is confirmed
    // if (passwordController.text == confirmpasswordController.text) {
    //   UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //     email: emailController.text,
    //     password: passwordController.text,
    //   );
    // try {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: receiverUserEmail)
        .get();
    if (query.docs.isEmpty) {
      //go to the sign up screen
      // print('test');
      wrongEmailMessage(('Username doesn`t exist').toString());
      return;
    }
    else if (receiverUserEmail == user.email!) {
      wrongEmailMessage(('Cant send mails to self!').toString());
      return;
    } 
    else {
      if (messageController.text.isNotEmpty) {
        await _chatService.sendMessage(
            receiverUserEmail, messageController.text);

        //clear the text controller after sending the message
        messageController.clear();
        // Navigator.pushAndRemoveUntil(
        //   context,
        //     MaterialPageRoute(builder: (context) => HomePage()),
        //       (Route<dynamic> route) => false,

        // );
      }
    }
// else {
//    //go to the login screen
// }
//     } on FirebaseAuthException catch (e) {
//       wrongEmailMessage(e.message.toString());
//     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            sendEmail(toController.text);
          },
          icon: Icon(Icons.send),
          label: Text('Send')),
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: ConstrainedBox(
          
          constraints: const BoxConstraints(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const SizedBox(height: 75),

              const SizedBox(height: 50),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '     To',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                    // fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              // To textfield
              MyTextField(
                controller: toController,
                hintText: 'abc@email.com',
                obscureText: false,
              ),

              const SizedBox(height: 20),

              // // Message textfield
              // MyTextField(
              //   controller: messageController,
              //   hintText: 'Body',
              //   obscureText: false,
              // ),
              // const SizedBox(height: 25),
              // Text(  'Message',
              //   style: TextStyle(
              //     color: Colors.grey[700],
              //     fontWeight: FontWeight.bold,
              //     fontSize: 20,),
              //     textAlign: TextAlign.center,

              // ),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '     Message',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontStyle: FontStyle.italic,
                    // fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: messageController,
                  obscureText: false,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      hintText: 'Body',
                      hintStyle: TextStyle(color: Colors.grey[500])),
                  maxLines: 6,
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
