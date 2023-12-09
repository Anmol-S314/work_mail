import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:work_mail/components/my_textfield.dart';
import 'package:work_mail/pages/chat_bubble.dart';
import 'package:work_mail/pages/intro_pages/calendar_page.dart';
import 'package:work_mail/services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  // final String receiverUserID;
  const ChatPage({
    super.key,
    required this.receiverUserEmail,
  });
  // required this.receiverUserID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserEmail, _messageController.text);
          
      //clear the text controller after sending the message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 208, 225, 240),
        appBar: AppBar(title: Text(widget.receiverUserEmail, style: TextStyle(fontSize:16),),elevation:20, backgroundColor: Color.fromARGB(255, 187, 221, 240), shadowColor: Colors.blue[200]),
        body: Column(children: [
          //messages
          Expanded(
            child: _buildMessageList(),
          ),

          //user input
          _buildMessageInput(),
          const SizedBox(height:25),
        ]));
  }

  //build message list
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.receiverUserEmail, _firebaseAuth.currentUser!.email!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading..");
          }

          return ListView(
              children: List<Widget>.from(snapshot.data!.docs
                  .map((document) => _buildMessageItem(document))
                  .toList()));
        });
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid ? CrossAxisAlignment.end:CrossAxisAlignment.start),
        mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid ? MainAxisAlignment.end : MainAxisAlignment.start),
        children: [
          Text(data['senderEmail']),
          // ChatBubble(message: data['senderEmail']),
          const SizedBox(height: 5),
          ChatBubble(message: data['message']),
          // Text(),
        ],
      ),
      ),
    );
  }

  // build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal :5.0),
      child: Row(
        children: [
          //textfield
          Expanded(
            // child: MyTextField(
            //   controller: _messageController,
            //   hintText: 'Enter Message',
            //   obscureText: false,
            // ),
                          
                child: TextField(
                  controller: _messageController,
                  obscureText: false,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      hintText: 'Enter Message',
                      hintStyle: TextStyle(color: Colors.blueAccent[500])),
                  maxLines: 1,
                ),
              
          ),
          IconButton(
            onPressed: sendMessage,
            icon: Icon(
              Icons.arrow_circle_up,
              size: 30,
            ),
          )
        ],
      ),
    );
  }
}
