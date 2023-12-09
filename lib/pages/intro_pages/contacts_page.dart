import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:work_mail/pages/chat_page.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 237, 237),
      body: _buildUserList(),
    );
  }
  //build a list of users except for the current user

  Widget _buildUserList() {
    FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
    }, SetOptions(merge: true));
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('loading..');
          }

          return ListView(
            children: List<Widget>.from(
              snapshot.data!.docs.map((doc) => _buildUserListItem(doc)),
            ),
          );
        });
  }

  //build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    //display all users except the current user
    if (_auth.currentUser!.email != data['email']) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        elevation: 10,
        color:Color.fromARGB(255, 236, 236, 236),
        surfaceTintColor: Colors.white,
        shadowColor: Colors.grey[100],
        margin: EdgeInsets.only(bottom: 20, left:20, right:20, top:5),
        child: ListTile(
        // tileColor: Color.fromARGB(255, 221, 211, 211),
        visualDensity: VisualDensity(horizontal: -4, vertical: -1),
        // contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        subtitle: Text(data['email']),
        title: Text(data['email'].split('@')[0]),
        // trailing: Icon(Icons.arrow_forward_ios),
        leading: Icon(
          Icons.account_circle_rounded,
          size: 40,
        ),
        selectedColor: Color.fromARGB(255, 255, 255, 255),
        // contentPadding: EdgeInsets.all(10),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserEmail: data['email'],
                // receiverUserID: data['uid'],
              ),
            ),
          );
        },
      ),
      );
    } else {
      return Container();
    }
  }
}
