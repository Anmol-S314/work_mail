import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:work_mail/pages/chat_page.dart';
import 'package:work_mail/pages/intro_pages/contacts_page.dart';
import 'package:work_mail/pages/intro_pages/calendar_page.dart';
import 'package:work_mail/pages/intro_pages/profile_page.dart';
import 'package:work_mail/pages/intro_pages/send_email_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signOut();
    FacebookAuth.instance.logOut();
    // providerData = FirebaseAuth.currentUser?.providerData;
    FirebaseAuth.instance.signOut();
  }

  int index = 0;
  final screens = [
    ContactsPage(),
    CalendarPage(),
    SendEmailPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
              icon: Icon(Icons.contacts),
              label: "Contacts",
              selectedIcon: Icon(Icons.contacts)),
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: "Calendar",
            selectedIcon: Icon(Icons.calendar_month),
          ),
          NavigationDestination(
              icon: Icon(Icons.edit),
              label: "Compose",
              selectedIcon: Icon(Icons.edit)),
          NavigationDestination(
              icon: Icon(Icons.account_circle),
              label: "Profile",
              selectedIcon: Icon(Icons.account_circle)),
        ],
        height: 70,
        elevation: 0,
        selectedIndex: index,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (index) => setState(() {
          this.index = index;
        }),
        backgroundColor: Color.fromARGB(255, 251, 251, 251),
        // selectedIndex:controller.selectedIndex.value,),
      ),

      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 20,
        toolbarHeight: 60,
        shadowColor: Colors.grey[300],
        backgroundColor: Colors.grey[300],
        title: Text(
          "Welcome ${user.email!.split('@')[0]}",
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      // drawer: Drawer(),
      // body: Center(
      //     child: Text(
      //   "LOGGED IN AS: ${user.email!}",
      //   style: const TextStyle(fontSize: 20),
      // )),
      // body: _buildUserList(),

      body: screens[index],
    );
  }

  //build a list of users except for the current user

  // Widget _buildUserList() {
  //   FirebaseFirestore.instance.collection('users').doc(user.uid).set({
  //     'uid': user.uid,
  //     'email': user.email,
  //   }, SetOptions(merge: true));
  //   return StreamBuilder<QuerySnapshot>(
  //       stream: FirebaseFirestore.instance.collection('users').snapshots(),
  //       builder: (context, snapshot) {
  //         if (snapshot.hasError) {
  //           return const Text('error');
  //         }

  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Text('loading..');
  //         }

  //         return ListView(
  //           children: List<Widget>.from(
  //             snapshot.data!.docs.map((doc) => _buildUserListItem(doc)),
  //           ),
  //         );
  //       });
  // }

  // //build individual user list items
  // Widget _buildUserListItem(DocumentSnapshot document) {
  //   Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

  //   //display all users except the current user
  //   if (_auth.currentUser!.email != data['email']) {
  //     return ListTile(
  //       title: Text(data['email']),
  //       onTap: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => ChatPage(
  //               receiverUserEmail: data['email'],
  //               receiverUserID: data['uid'],
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //   } else {
  //     return Container();
  //   }
  // }

  // Widget _buildUserListItem(DocumentSnapshot document) {
  //   Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

  //   //display all users except the current user
  //   if (_auth.currentUser!.email != data['email']) {
  //     return ListTile(
  //       title: Text(data['email']),
  //       onTap: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => ChatPage(
  //               receiverUserEmail: data['email'],
  //               receiverUserID: data['uid'],
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //   } else {
  //     return Container();
  //   }
  // }
}
