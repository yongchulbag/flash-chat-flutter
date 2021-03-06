import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  String messageText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMessage() async {
  //   final messages = await _firestore.collection('messages').get();
  //   for (var message in messages.docs)
  //     {
  //       print(message.data());
  //     }
  // }

  void getMessageStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                getMessageStream();
                // _auth.signOut();
                // Navigator.pop(context);
              }),
        ],
        title: Text('=Turtle Chat='),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('messages').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlue,
                      ),
                    );
                  }
                    final messages = snapshot.data.docs;
                    List<BubbleMessage> messageWidgets = [];
                    for (var message in messages) {
                      final messageText = (message.data() as Map<String, dynamic>)['text'];
                      final messageSender = (message.data() as Map<String, dynamic>)['sender'];
                      final messageWidget = BubbleMessage(messageText: messageText, messageSender: messageSender);
                      messageWidgets.add(messageWidget);
                    }
                    return Expanded(
                      child: ListView(
                        children: messageWidgets,
                      ),
                    );
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      print(messageText);
                      print(loggedInUser.email);

                      _firestore.collection('messages').add({
                        'sender': loggedInUser.email,
                        'text': messageText,
                        "timestamp": FieldValue.serverTimestamp(),
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BubbleMessage extends StatelessWidget {
  BubbleMessage({this.messageText, this.messageSender});

  final String messageText;
  final String messageSender;

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(messageSender, style: TextStyle(fontSize: 12, color: Colors.black54),),
            Material(
              borderRadius: BorderRadius.circular(30),
              elevation: 5,
              color: Colors.green,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text('$messageText',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20),),
              ),
            ),
          ],
        ),
      );
  }
}
