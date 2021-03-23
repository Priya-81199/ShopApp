import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:lilly_app/app/route.gr.dart';

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({@required this.messageContent, @required this.messageType});
}

class AdminChatScreen extends StatefulWidget {
  static const String id = 'admin_chat_screen';
  @override
  _AdminChatScreenState createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  final messageTextController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  var selectedUser = 'rajs80266@gmail.com';
  String messageText;
  bool isChanged = true;
  List<ChatMessage> messages = [
    //ChatMessage(messageContent: "Hello, Will", messageType: "sender"),
  ];
  var messageIndex = 0;

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  void getMessages() async {

    var chats = await _firestore.collection(selectedUser + '_chat').get();
    List<ChatMessage> tempmessages = [];
    var allchats = chats.docs;
    allchats.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
    for (messageIndex = messageIndex;
        messageIndex < allchats.length;
        messageIndex++) {
      var chat = allchats[messageIndex];
      print(chat['message']);
      if (chat['receiver'] == selectedUser) {
        tempmessages.add(
          ChatMessage(messageContent: chat['message'], messageType: "sender"),
        );
      } else {
        tempmessages.add(
          ChatMessage(messageContent: chat['message'], messageType: "receiver"),
        );
      }
    }
    tempmessages = tempmessages.reversed.toList();

    setState(() {
      messages = [...tempmessages, ...messages]; //aare solveQueries jaisa... ha wo baki hai
    });
  }



  bool activeQueriesFetched = false;
  List<dynamic> activeQueries = [];
  void getActiveQueries() async {
    await _firestore.collection('active_queries').get().then((value) => {
      activeQueries = value.docs,
    });
    setState(() {
      activeQueriesFetched = true;
    });
  }

  void printing() {
    getMessages();
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(milliseconds: 60000), printing);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<Widget> activeQueriesWidget = [];
    if (!activeQueriesFetched)
      getActiveQueries();
    else {
      activeQueries.forEach((result) {
        activeQueriesWidget.add(SingleChildScrollView(
          child: Container(
            color: Colors.blueGrey.shade400,
            height: 75,
            width: 400,
            child: FlatButton(
              onPressed: () async{
                setState(() {
                  messages = [];
                  messageIndex = 0;
                  selectedUser = result['username'];
                });
                getMessages();
                // var session = FlutterSession();
                // selectedUser = await session.set('selectedUser', result['username']);
                // ExtendedNavigator.of(context).push(Routes.adminChatScreen);
              },
              child: Text(
                result['username'],
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'RocknRoll'
                ),
              ),
            ),
          ),
        )
        );
        activeQueriesWidget.add(
          Container(
            width: 400,
            child: Divider(
              color: Colors.black26,
              height: 2,
              thickness: 1,
            ),
          ),
        );
      });
    }
    void f(){
      setState(() {

      });
    }
    return Scaffold(
      appBar: buildAppBar(context, f),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: height,
            width: 200,
            color: Colors.blueGrey.shade100,
            child: Column(
              children: activeQueriesWidget,
            ),
          ),
          Container(
            height: height,
            width: width - 200,
            child: Column(
              children: <Widget>[
                Container(
                  height: height * 0.82,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: messages.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    //physics: NeverScrollableScrollPhysics(),
                    reverse: true,
                    itemBuilder: (context, index) {
                      return Container(
                        padding:
                            EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                        child: Align(
                          alignment: (messages[index].messageType == "receiver"
                              ? Alignment.topLeft
                              : Alignment.topRight),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: (messages[index].messageType == "receiver"
                                  ? Colors.grey.shade200
                                  : Colors.blue[200]),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Text(
                              messages[index].messageContent,
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 15,
                      ),
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
                          },
                          controller: messageTextController,
                          onChanged: (value) {
                            setState(() {
                              messageText = value;
                            });
                          },
                          decoration: InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          setState(() {
                            messageTextController.text = '';
                          });
                          await _firestore.collection(selectedUser + '_chat').add({
                            'sender': adminEmail,
                            'receiver': selectedUser,
                            'message': messageText,
                            'timestamp': FieldValue.serverTimestamp(),
                          });
                          printing();
                        },
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                        backgroundColor: Colors.blue,
                        elevation: 0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
