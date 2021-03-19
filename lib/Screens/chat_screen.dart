import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lilly_app/Screens/Components.dart';

class ChatMessage{
  String messageContent;
  String messageType;
  ChatMessage({@required this.messageContent, @required this.messageType});
}

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  String messageText;
  bool isChanged=true;
  List<ChatMessage> messages = [
    //ChatMessage(messageContent: "Hello, Will", messageType: "sender"),
  ];
  var messageIndex = 0;

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  void getMessages() async{
    await getCurrentUser();
    var chats = await _firestore.collection(loggedInUser.email + '_chat').get();
    List<ChatMessage> tempmessages = [];
    var allchats = chats.docs;
    allchats.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
    for(messageIndex=messageIndex; messageIndex<allchats.length; messageIndex++){
      var chat = allchats[messageIndex];
      if(chat['sender']==loggedInUser.email){
        tempmessages.add(ChatMessage(messageContent: chat['message'], messageType: "sender"),);
      }
      else{
        tempmessages.add(ChatMessage(messageContent: chat['message'], messageType: "receiver"),);
      }
    };
    tempmessages = tempmessages.reversed.toList();

    setState(() {
      messages = [...tempmessages, ...messages];
    });
  }

  void getCurrentUser() async {
    try{
      final user = await _auth.currentUser;
      if(user != null){
        loggedInUser = user;
      } }
    catch(e){
      print(e);
    }
  }
  void printing(){
    getMessages();
  }
  void f(){
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(milliseconds: 60000), printing);
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar:buildAppBar(context, f),
      body: Column(
        children: <Widget>[
          Container(
            height: height*0.82,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: messages.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10,bottom: 10),
              //physics: NeverScrollableScrollPhysics(),
              reverse: true,
              itemBuilder: (context, index){
                return Container(
                  padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
                  child: Align(
                    alignment: (messages[index].messageType == "receiver"?Alignment.topLeft:Alignment.topRight),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (messages[index].messageType  == "receiver"?Colors.grey.shade200:Colors.blue[200]),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(messages[index].messageContent, style: TextStyle(fontSize: 15),),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
            height: 60,
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: <Widget>[

                SizedBox(width: 15,),
                Expanded(
                  child: TextField(
                    onSubmitted: (value) async{
                      setState(() {
                        messageTextController.text = '';
                      });
                      await _firestore.collection(loggedInUser.email + '_chat').add({
                        'sender':loggedInUser.email,
                        'receiver':adminEmail,
                        'message':messageText,
                        'timestamp':FieldValue.serverTimestamp(),
                      });
                      getMessages();
                      sendToAdmin();
                    },
                    controller: messageTextController,
                    onChanged: (value){
                      setState(() {
                        messageText = value;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: "Write message...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none
                    ),
                  ),
                ),
                SizedBox(width: 15,),
                FloatingActionButton(
                  onPressed: () async{
                    setState(() {
                      messageTextController.text = '';
                    });
                    await _firestore.collection(loggedInUser.email + '_chat').add({
                      'sender':loggedInUser.email,
                      'receiver':adminEmail,
                      'message':messageText,
                      'timestamp':FieldValue.serverTimestamp(),
                    });
                    getMessages();
                    sendToAdmin();
                  },
                  child: Icon(Icons.send,color: Colors.white,size: 18,),
                  backgroundColor: Colors.blue,
                  elevation: 0,
                ),
              ],

            ),
          ),
        ],
      ),
    );

  }
}

