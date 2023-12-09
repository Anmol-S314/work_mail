import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:work_mail/components/my_button.dart';

class ProfilePage extends StatefulWidget {
  
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // sign user out method
  void signUserOut() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signOut();
    // providerData = FirebaseAuth.currentUser?.providerData;
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
            
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 70,
            backgroundImage: AssetImage("lib/images/profile2.png"),
          ),
          const SizedBox(height:10),

           Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              '${user.email!.split('@')[0]}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),

          // const SizedBox(height: ),
            Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              '${user.email!}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 12),
          // Reset pwd button
          MyButton(
            text: 'Sign Out',
            onTap: signUserOut,
          ),
          

          // MaterialButton(
          //   onPressed: passwordReset,
          //   child: Text("Reset Password"),
          //   color: Colors.deepPurple[200],
          // )
        ],
      ),
    );
  }
  
}

