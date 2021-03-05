import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:intl/intl.dart';
import 'package:lilly_app/app/route.gr.dart';

class SolveQueries extends StatefulWidget{
  @override
  _SolveQueriesState createState() => _SolveQueriesState();
}

class _SolveQueriesState extends State<SolveQueries>{
  final messageTextController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  String messageText;
  var selectedUser;

  @override
  void initState(){
    super.initState();
    setLastVisited();
    getCurrentUser();
    setSelectedUser();
  }

  void setSelectedUser() async{
    var session = FlutterSession();
    selectedUser = await session.get('selectedUser');
  }

  void getCurrentUser() async {
    try{
      final user = await _auth.currentUser;
      if (user != null) {
        if(user.email == adminEmail){
          loggedInUser = user;
        }
        else{
          ExtendedNavigator.of(context).popAndPush(Routes.homePage);
        }
      }
      else{
        ExtendedNavigator.of(context).popAndPush(Routes.welcomeScreen);
      }
    } catch (e) {
      print(e);
    }
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

  void setLastVisited() async {
    var session = FlutterSession();
    await session.set("last_visited", Routes.solveQueries);
  }

  @override
  Widget build(BuildContext context) {
    void f() {
      setState(() {});
    }

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
                  // selectedUser = result['username'];
                  var session = FlutterSession();
                  selectedUser = await session.set('selectedUser', result['username']);
                  ExtendedNavigator.of(context).push(Routes.solveQueries);
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
        ));
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

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: buildAppBar(context, f),
      body: LayoutBuilder(builder: (context, constraints) {
        var width = constraints.maxWidth - 400;
        var height = constraints.maxHeight;
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: height,
                color: Colors.blueGrey.shade100,
                child: Column(
                  children: activeQueriesWidget,
                ),
              ),
              Container(
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('chat_messages')
                          .orderBy('Timestamp')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.lightBlueAccent,
                            ),
                          );
                        }
                        final messages = snapshot.data.docs.reversed;
                        List<MessageBubble> messageBubbles = [];
                        for (var message in messages) {
                          final messageText = message.get('text');
                          final messageSender = message.get('sender');
                          final currenUser = adminEmail;

                          final messageBubble = MessageBubble(
                            sender: '',
                            text: messageText,
                            isMe: currenUser == messageSender,
                          );

                          if (currenUser == messageSender ||
                              messageSender == selectedUser) {
                            if (currenUser == messageSender) {
                              final messageReceiver = message.get('receiver');
                              if (messageReceiver != selectedUser) continue;
                            }
                            messageBubbles.add(messageBubble);
                          }
                        }
                        return Expanded(
                          child: ListView(
                            reverse: true,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 20.0),
                            children: messageBubbles,
                          ),
                        );
                      },
                    ),
                    Container(
                      decoration: kMessageContainerDecoration,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: messageTextController,
                              onChanged: (value) {
                                //Do something with the user input.
                                messageText = value;
                              },
                              decoration: kMessageTextFieldDecoration,
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              //Implement send functionality.
                              messageTextController.clear();
                              var now = DateTime.now();
                              String date =
                                  '${now.day.toString()}/${now.month.toString()}';
                              String time =
                                  '${DateFormat.jm().format(now).toString()}';
                              if(messageText != null) {
                                _firestore.collection('chat_messages').add({
                                  'text': messageText,
                                  'sender': adminEmail,
                                  'date': date,
                                  'time': time,
                                  'Timestamp': FieldValue.serverTimestamp(),
                                  'receiver': selectedUser,
                                });
                              }
                            },
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
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
      }),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
            elevation: 5.0,
            color: isMe ? Colors.white : Colors.blueGrey,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(text,
                  style: TextStyle(
                    fontFamily: 'RocknRoll',
                    color: isMe ? Colors.black : Colors.white,
                    fontSize: 15,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
