import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:lilly_app/app/route.gr.dart';
import 'package:lilly_app/mockData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lilly_app/Screens/ProductDetails.dart';
import 'dart:math';
import 'package:flutter_session/flutter_session.dart';
import 'package:lilly_app/Screens/ProductList.dart';
import 'package:lilly_app/main.dart';
import 'login.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:scroll_to_id/scroll_to_id.dart';

final scrollController = ScrollController();

ScrollToId scrollToId = ScrollToId(scrollController: scrollController);

class homePage extends StatefulWidget {
  static const String id = "homePage";
  @override
  _homePageState createState() => _homePageState();
}

final _firestore = FirebaseFirestore.instance;

class _homePageState extends State<homePage> {
  final messageTextController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  String messageText;

  @override
  void initState() {
    super.initState();
    setLastVisited();
    getCurrentUser();
  }

  void setLastVisited() async {
    var session = FlutterSession();
    await session.set("last_visited", Routes.homePage);
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  List<Map<dynamic, dynamic>> products = [];

  void getData(String collection) async {
    await _firestore.collection(collection).get().then((value) {
      value.docs.forEach((result) {
        if (collection == 'products') products.add(result.data());
      });
    });
  }

  _homePageState() {
    getData('products');
  }

  var selectedCategory = 'Kids';
  @override
  Widget build(BuildContext context) {
    void f() {
      setState(() {});
    }

    var category = <Widget>[];
    categories.sort((a, b) => a['name'].compareTo(b['name']));

    for (var i = 0; i < categories.length; i++) {
      category.add(
        FlatButton(
          onPressed: () {
            setState(() {
              selectedCategory = categories[i]['name'];
            });
          },
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.asset('images/' + categories[i]['image']),
            ),
          ),
        ),
      );
    }

    var subcategory = <Widget>[];
    subcategory.add(
      SizedBox(width: 5),
    );
    for (var i = 0; i < subcategories.length; i++) {
      if (subcategories[i]['category'] == selectedCategory) {
        subcategory.add(
          SizedBox(width: 5),
        );
        subcategory.add(
          FlatButton(
            onPressed: () {
              ExtendedNavigator.of(context).push(Routes.productList,
                  arguments: ProductListArguments(
                      subcategory: subcategories[i]['name']));
            },
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Image.asset('images/' + subcategories[i]['image']),
              ),
            ),
          ),
        );
        subcategory.add(
          SizedBox(width: 5),
        );
      }
    }
    subcategory.add(
      SizedBox(width: 5),
    );

    var product = <Widget>[];
    products.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
    product.add(
      SizedBox(width: 5),
    );
    for (var i = 0; i < min(20, products.length); i++) {
      product.add(
        SizedBox(width: 5),
      );
      product.add(
        FlatButton(
          onPressed: () {},
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.asset('images/' + products[i]['images'][0]),
            ),
          ),
        ),
      );
      product.add(
        SizedBox(width: 5),
      );
    }
    product.add(
      SizedBox(width: 5),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xf6f5f5),
        appBar: buildAppBar(context, f),
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     Container(
                    //       width: 300,
                    //       child: TextFormField(
                    //         style: TextStyle(
                    //           color: Colors.indigo.shade900,
                    //           decorationColor: Colors.indigo.shade900
                    //         ),
                    //         decoration: InputDecoration(
                    //           focusColor: Colors.indigo.shade900,
                    //           labelText: 'Search',
                    //           labelStyle: TextStyle(color: Colors.indigo.shade900),
                    //         ),
                    //       ),
                    //     ),
                    //     Icon(Icons.search),
                    //   ],
                    // ),

                    // Text(
                    //   'Categories',
                    //   style: TextStyle(
                    //     fontFamily: 'Lobster',
                    //     fontSize: 30,
                    //     fontWeight: FontWeight.w700,
                    //   ),
                    // ),

                    Container(
                      color: Color.fromRGBO(211, 224, 234, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlatButton(
                            hoverColor: Color.fromRGBO(246, 245, 245, 1),
                            onPressed: () {
                              selectCat('Gents');
                            },
                            child: Container(
                              width: 250,
                              height: 70,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    'Men Clothing',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Handlee',
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          FlatButton(
                            hoverColor: Color.fromRGBO(246, 245, 245, 1),
                            onPressed: () {
                              selectCat('Ladies');
                            },
                            child: Container(
                              width: 250,
                              height: 70,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    'Women Clothing',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Handlee',
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          FlatButton(
                            hoverColor: Color.fromRGBO(246, 245, 245, 1),
                            onPressed: () {
                              selectCat('Kids');
                            },
                            child: Container(
                              width: 250,
                              height: 70,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    'Kids Clothing',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Handlee',
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          FlatButton(
                            hoverColor: Color.fromRGBO(246, 245, 245, 1),
                            onPressed: () {
                              selectCat('Accessories');
                            },
                            child: Container(
                              width: 250,
                              height: 70,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    'Accessories',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Handlee',
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 500.0,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          autoPlay: true,
                          aspectRatio: 2.0,
                          enlargeCenterPage: true,
                          autoPlayAnimationDuration: Duration(seconds: 1),
                        ),
                        items: category,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Text(
                      'Sub Categories',
                      style: TextStyle(
                        fontFamily: 'Lobster',
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 300.0,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: subcategory,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'New Arrivals',
                      style: TextStyle(
                        fontFamily: 'Lobster',
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 120.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: product,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            chat
                ? Positioned(
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
                                    final messageReceiver =
                                        message.get('receiver');
                                    if (messageReceiver != currenUser) continue;
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

                                    _firestore.collection('chat_messages').add({
                                      'text': messageText,
                                      'sender': loggedInUser.email,
                                      'date': date,
                                      'time': time,
                                      'Timestamp': FieldValue.serverTimestamp(),
                                    });

                                    sendToAdmin();
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
                  )
                : Container()
          ],
        ),
        floatingActionButton: FutureBuilder(
            future: FlutterSession().get('isUserSet'),
            builder: (context, snapshot) {
              return snapshot.hasData && snapshot.data
                  ? Container(
                      height: 60.0,
                      width: 60.0,
                      child: FloatingActionButton(
                        backgroundColor: Color.fromRGBO(39, 102, 120, 1),
                        child: Icon(
                          Icons.chat,
                        ),
                        elevation: 10,
                        onPressed: () {
                          setState(() {
                            chatScreen();
                          });
                        },
                      ),
                    )
                  : Container();
            }),
      ),
    );
  }

  bool chat = false;
  void chatScreen() {
    setState(() {
      chat = !chat;
    });
  }

  void selectCat(String catName) {
    setState(() {
      selectedCategory = catName;
    });
    // scrollToId.animateTo(
    //     'b',
    //     duration: Duration(milliseconds: 500),
    //     curve: Curves.ease
    // );
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
                fontFamily: 'Lobster', fontSize: 12.0, color: Colors.black54),
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
                    fontFamily: 'Lobster',
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
