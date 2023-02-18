import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqq_flutter2/constants.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  bool? me;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future<void> callback() async {
    if(messageController.text.length > 0) {
      await _firestore.collection('messages').add({
        'text': messageController.text,
        'from': user?.email,
        'me': true,
      });
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent, 
        curve: Curves.easeOut, 
        duration: const Duration(milliseconds: 300));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back, color: kBlackColor800,),
        title: Text("Chat Room", style: TextStyle(fontSize: 24, color: kBlackColor800),),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }, 
          icon: Icon(Icons.close),
          color: kBlackColor800,)
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('messages').snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());

                  List<DocumentSnapshot> docs = snapshot.data!.docs;
                  List<Widget> messages = docs.map((doc) => Message(
                    from: doc.get('from'),
                    text: doc.get('text'),
                    me: user?.email == doc.get('from'))).toList();
                  return ListView(
                    controller: scrollController,
                    children: [
                      ...messages,
                    ],
                  );
                },
                )),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: "Enter a Message...",
                            border: OutlineInputBorder(),
                          ),
                        )),
                        SendButton(text: "Send", callback: callback),
                    ],
                  ),
                )
          ],
        ),
      ),
    );
  }
}

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;
  const SendButton({super.key, required this.text, required this.callback});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callback,
      child: Text(text, style: TextStyle(color: kWhiteColor),),
    );
  }
}

class Message extends StatelessWidget {
  final String from;
  final String text;
  final bool me;

  const Message({super.key, required this.from, required this.text, required this.me});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(from),
          Material(
            color: me ? Colors.teal : Colors.red,
            borderRadius: BorderRadius.circular(10.0),
            elevation: 6.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Text(
                text,
              ),
            ),
          )
        ],
      ),
    );
  }
}