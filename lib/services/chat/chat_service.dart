import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:work_mail/model/message.dart';

class ChatService extends ChangeNotifier {
  //get auth and firestore instances
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SEND Messages

  Future<void> sendMessage(String receiverEmail, String message) async {
    //get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //new message

    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverEmail: receiverEmail,
      timestamp: timestamp,
      message: message,
    );

    //construct chat room id from current user id and reciever id
    List<String> ids = [currentUserEmail, receiverEmail];
    ids.sort();
    String chatRoomId = ids.join("_");
    //add new message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // GET Messages
  Stream<QuerySnapshot> getMessages(String userEmail, String otherUserEmail) {
    // construct chat room id from user ids(sorted to ensure matching user ids)
    List<String> ids = [userEmail, otherUserEmail];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp',descending: false).snapshots();
  }
}
