import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lilly_app/app/route.gr.dart' as rg;
import 'package:lilly_app/app/route.gr.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:intl/intl.dart';

//Classes
class Data {
  final dynamic product;
  Data({
    this.product,
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["product"] = product;
    return data;
  }
}

// Global variables
final storage = FirebaseStorage.instance;
final _auth = FirebaseAuth.instance;
User user = _auth.currentUser;
final _firestore = FirebaseFirestore.instance;
User loggedInUser;
String messageText;
final messageTextController = TextEditingController();
bool chat = false;

//Functions
void chatScreen(Function() f) {
  chat = !chat;
  f();
}

String getImageURL(String imageName) {
  return 'https://firebasestorage.googleapis.com/v0/b/lillyapp-d0f89.appspot.com/o/product_images%2F${imageName}?alt=media';
}

void uploadPhotos(PlatformFile file) async {
  await storage.ref('product_images/${file.name}').putData(file.bytes);
}

launchWhatsApp() async {
  final link = WhatsAppUnilink(
    phoneNumber: '+91-9930865664',
    text: "Hey!",
  );
  await launch('$link');
}

void sendToAdmin() async {
  bool flag;
  var username = loggedInUser.email;
  var Timestamp = FieldValue.serverTimestamp();
  await _firestore.collection('active_queries').get().then((value) => {
        flag = true,
        value.docs.forEach((result) {
          // print(result['username']);
          if (result['username'] == username) {
            print('updation');
            _firestore
                .collection('active_queries')
                .doc(result.id)
                .update({'Timestamp': Timestamp});
            flag = false;
          }
        }),
        if (flag)
          {
            _firestore.collection('active_queries').add({
              'username': loggedInUser.email,
              'Timestamp': Timestamp,
            })
          }
      });
  return;
}

//Constants
String adminEmail = 'princymishra10@gmail.com';

//Widgets
class ChatOptions extends StatelessWidget {
  const ChatOptions({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _auth.currentUser != null
        ? Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 60, 0),
              child: FloatingActionButton(
                backgroundColor: Colors.green.shade600,
                child: FaIcon(FontAwesomeIcons.whatsapp),
                onPressed: () {
                  launchWhatsApp();
                },
              ),
            ),
          )
        : Container();
  }
}

Positioned buildChat() {
  return Positioned(
    bottom: 90,
    right: 20,
    child: Container(
      constraints: BoxConstraints(
        maxHeight: 500,
        maxWidth: 300,
      ),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey,
              offset: Offset(1.0, 1.0),
              blurRadius: 20.0,
            ),
          ],
          color: Color.fromRGBO(39, 102, 120, 1),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30))),
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
                final currenUser = loggedInUser.email;

                final messageBubble = MessageBubble(
                  sender: '',
                  text: messageText,
                  isMe: currenUser == messageSender,
                );

                if (currenUser == messageSender ||
                    messageSender == adminEmail) {
                  if (messageSender == adminEmail) {
                    final messageReceiver = message.get('receiver');
                    if (messageReceiver != currenUser) continue;
                  }
                  messageBubbles.add(messageBubble);
                }
              }
              return Expanded(
                child: ListView(
                  reverse: true,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
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
                    style: TextStyle(
                      color: Colors.white,
                    ),
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
                    String time = '${DateFormat.jm().format(now).toString()}';

                    if (messageText != null) {
                      _firestore.collection('chat_messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                        'date': date,
                        'time': time,
                        'Timestamp': FieldValue.serverTimestamp(),
                      });
                      sendToAdmin();
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
  );
}

Widget buildChatWrapper(Function() f) {
  return _auth.currentUser != null
      ? Tooltip(
          message: 'Chat with us',
          child: FloatingActionButton(
            backgroundColor: Color.fromRGBO(39, 102, 120, 1),
            child: Icon(
              Icons.chat,
            ),
            elevation: 10,
            onPressed: () {
              chatScreen(f);
            },
          ),
        )
      : Container();
}

Widget buildChatStack(void f()) {
  // return Stack(
  //   children: <Widget>[
  //     ChatOptions(),
  //     Align(
  //       alignment: Alignment.bottomRight,
  //       child: buildChatWrapper(f),
  //     ),
  //   ],
  // );

  return _auth.currentUser != null ?
  Align(
    alignment: Alignment.bottomRight,
    child: Container(
      height: 50,
      width: 200,
      child: Row(
        children: [
          FlatButton(
            onPressed: () {
              print('here 1');
              launchWhatsApp();
            },
            child: FaIcon(
              FontAwesomeIcons.whatsapp,
              color: Colors.green,
              size: 40,
            ),
          ),
          FlatButton(
            onPressed: () {
              print('here 2');
              // f();
              // chatScreen(f);
            },
            child: Icon(
              Icons.chat,
              color: Colors.indigo,
              size: 40,
            ),
          ),
        ],
      ),
    ),
  ): Container();
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
            style: TextStyle(
                fontFamily: 'Roboto', fontSize: 12.0, color: Colors.black54),
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
            color: isMe ? Colors.white : Colors.blueGrey.shade300,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(text,
                  style: TextStyle(
                    fontFamily: 'Roboto',
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

Widget getCard(
    BuildContext context, dynamic product, dynamic width, dynamic height) {
  var nameFontSize = width / 232 * 18;
  var priceFontSize = width / 232 * 16;
  var descriptionFontSize = width / 232 * 12;
  return FlatButton(
    onPressed: () async {
      var session = FlutterSession();
      await session.set("argument_prod", Data(product: product));
      ExtendedNavigator.of(context).push(Routes.productDetails);
    },
    child: Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Column(
        children: [
          Container(
              height: 0.65 * height,
              child: Image.network(getImageURL(product['images'][0]))),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              product['name'],
              style: TextStyle(
                fontFamily: 'Lobster',
                fontSize: nameFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              product['description'],
              style: TextStyle(
                fontFamily: 'Handlee',
                fontSize: descriptionFontSize,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              '₹' + product['price'],
              style: TextStyle(
                fontFamily: 'Lobster',
                fontSize: priceFontSize,
                fontWeight: FontWeight.w500,
                color: Colors.pinkAccent,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

AppBar buildAppBar(BuildContext context, Function() f) {
  return AppBar(
    backgroundColor: Color.fromRGBO(39, 102, 120, 1),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FlatButton(
          hoverColor: Colors.transparent,
          onPressed: () {
            ExtendedNavigator.of(context).push(rg.Routes.homePage);
          },
          child: Text(
            'Lilly',
            style: TextStyle(
              fontFamily: 'Lobster',
              fontSize: 40,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          child: FutureBuilder(
            future: FlutterSession().get('isUserSet'),
            builder: (context, snapshot) {
              return Container(
                child: Row(
                  children: [
                    snapshot.hasData
                        ? ((snapshot.data) && (user.email != adminEmail))
                            ? Tooltip(
                                message: 'My Cart',
                                child: IconButton(
                                    hoverColor: Colors.transparent,
                                    icon: Icon(Icons.shopping_cart_rounded),
                                    onPressed: () {
                                      ExtendedNavigator.of(context)
                                          .push(Routes.cart);
                                    }),
                              )
                            : Container()
                        : Container(),
                    snapshot.hasData
                        ? ((snapshot.data) && (user.email != adminEmail))
                            ? Tooltip(
                                message: 'My Orders',
                                child: IconButton(
                                    hoverColor: Colors.transparent,
                                    icon: Icon(Icons.shopping_bag_rounded),
                                    onPressed: () {
                                      ExtendedNavigator.of(context)
                                          .push(Routes.orders);
                                    }),
                              )
                            : Container()
                        : Container(),
                    Container(
                      width: 150,
                      height: 100,
                      child: FlatButton(
                        hoverColor: Color.fromRGBO(211, 224, 234, 1),
                        child: Text(
                          snapshot.hasData
                              ? snapshot.data
                                  ? 'Logout'
                                  : 'Login'
                              : 'Loading',
                          style: TextStyle(
                            fontFamily: 'Lobster',
                            fontSize: 24,
                          ),
                        ),
                        onPressed: () async {
                          if (snapshot.hasData) {
                            if (snapshot.data) {
                              FirebaseAuth.instance.signOut();
                              await FlutterSession().set('isUserSet', false);
                              ExtendedNavigator.of(context)
                                  .push(rg.Routes.homePage);
                              f();
                            } else {
                              ExtendedNavigator.of(context)
                                  .push(rg.Routes.loginScreen);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

const kSendButtonTextStyle = TextStyle(
  color: Colors.indigo,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);
const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  hintStyle: TextStyle(color: Colors.white),
  border: InputBorder.none,
);
const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.indigoAccent, width: 2.0),
  ),
);
const kTextFieldDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.indigo),
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.indigo, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.indigo, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
