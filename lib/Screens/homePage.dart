import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:lilly_app/mockData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lilly_app/Screens/ProductDetails.dart';
import 'dart:math';
import 'package:flutter_session/flutter_session.dart';
import 'package:lilly_app/Screens/ProductList.dart';
import 'package:lilly_app/main.dart';
import 'login.dart';
import 'package:intl/intl.dart';


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

    getCurrentUser();
  }

  void getCurrentUser() async {
    try{
      final user = await _auth.currentUser;
      if(user != null){
        loggedInUser = user;
        print(loggedInUser.email);
      } }
    catch(e){
      print(e);
    }
  }

  void messageStream() async {
    await for(var snapshot in _firestore.collection('messages').snapshots()){
      for (var message in snapshot.docs){
        print(message.data());
      }
    }
  }
  List<Map<dynamic, dynamic>> products = [];


  void getData(String collection) async{
    await _firestore.collection(collection).get().then((value) {
      value.docs.forEach((result) {
        if(collection == 'products')
          products.add(result.data());
      });
    });

  }
  _homePageState(){
    getData('products');
  }

  var selectedCategory = 'Gents';
  @override
  Widget build(BuildContext context) {

    //isUserSet = (isUserSet)? isUserSet :false;
    var category = <Widget>[];
    categories.sort((a, b) => a['name'].compareTo(b['name']));
    var colour1 = [
      Colors.red.withOpacity(0.0),
      Colors.red.withOpacity(0.0),
    ];
    var colour2 = [
      Colors.black.withOpacity(0.5),
      Colors.black.withOpacity(0.5),
    ];
    var colour3 = [];
    category.add(
      SizedBox(width: 5),
    );
    for (var i = 0; i < categories.length; i++) {
      if(categories[i]['name']==selectedCategory) {
        colour3=colour1;
      }
      else {
        colour3=colour2;
      }

      category.add(
        SizedBox(width: 5),
      );
      category.add(
        GestureDetector(
          onTap: () {
              setState(() {
                selectedCategory = categories[i]['name'];
              });
              },

          child: Stack(
            children: <Widget>[
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.asset('images/' + categories[i]['image']),
                ),
              ),
              Container(
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.white,
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: colour3,
                    stops: [
                      0.0,
                      1.0
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      category.add(
          SizedBox(width: 5),
      );
    }
    category.add(
      SizedBox(width: 5),
    );


    var subcategory = <Widget>[];
    subcategory.add(
      SizedBox(width: 5),
    );
    //print(subcategories);
    for (var i = 0; i < subcategories.length; i++) {
      //print(subcategories[i]);
      if(subcategories[i]['category'] == selectedCategory) {
        subcategory.add(
          SizedBox(width: 5),
        );
        subcategory.add(
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, new MaterialPageRoute(builder: (BuildContext context) => new ProductList(subcategories[i]['name']))
              );
              //print(subcategories[i]['name']);//TODO:route to productList with these params
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
    for (var i = 0; i < min(20,products.length); i++) {
      product.add(
        SizedBox(width: 5),
      );
      product.add(
        GestureDetector(
          onTap: () {
            //print(products[i]['name']);
          },
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.asset('images/' + products[i]['images'][0]['image']),
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
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(39,102,120 ,1),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lilly',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                child: FutureBuilder(
                  future: FlutterSession().get('isUserSet'),
                  builder: (context, snapshot) {
                    return FlatButton(
                        child: Text( snapshot.hasData ? (snapshot.data ? 'Logout':'Login'):'Loading'),

                        onPressed: (){
                          isUserSet?
                          FirebaseAuth.instance.signOut()
                          //isUserSet = false
                          :
                          Navigator.push(
                          context, new MaterialPageRoute(builder: (BuildContext context) => new LoginScreen())
                    );

                  },
                );
                  },
                ),
              ),
            ],
          ),
        ),
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
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 120.0,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(

                          children: category,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Sub Categories',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 120.0,
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
                      'New Arivals',
                      style: TextStyle(
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
            chat ? Positioned(
              top:140,
              right: 80,
              child: Container(
                //width: ,
                constraints: BoxConstraints(
                  maxHeight:500,
                  maxWidth: 500,
                ),
                decoration: BoxDecoration(
                boxShadow: [
                    BoxShadow(
                    color: Colors.blueGrey,
                    offset: Offset(1.0, 1.0),
                    blurRadius: 20.0,
                    ),
                    ],
                    color: Color.fromRGBO(39,102,120 ,1),
                    borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                    bottomLeft:Radius.circular(30)
                  )

                ),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection('messages').orderBy('Timestamp').snapshots(),
                      builder: (context , snapshot) {
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


                          final messageBubble = MessageBubble(sender: messageSender, text: messageText,isMe: currenUser==messageSender,);

                          messageBubbles.add(messageBubble);
                        }
                        return Expanded(
                          child: ListView(
                            reverse: true,
                            padding: EdgeInsets.symmetric(horizontal: 10.0 , vertical: 20.0),
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
                              String date = '${now.day.toString()}/${now.month.toString()}';
                              String time = '${DateFormat.jm().format(now).toString()}';

                              _firestore.collection('chat_messages').add({
                                'text': messageText,
                                'sender': loggedInUser.email,
                                'date': date,
                                'time': time,
                                'Timestamp': FieldValue.serverTimestamp(),
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
            ):
                Container()
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromRGBO(39,102,120 ,1),
          child: Icon(
            Icons.chat,
          ),
          elevation: 10,
          onPressed: (){
            setState(() {
              chatScreen();
            });

          },
        ),
      ),
    );
  }
  bool chat = false;
  void chatScreen(){
    if(chat)
      chat = false;
    else
      chat = true;
  }


}

class MessageBubble extends StatelessWidget {

  MessageBubble({this.sender,this.text , this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
                fontSize: 12.0,
                color: Colors.black54
            ),
          ),
          Material(
            borderRadius: isMe?BorderRadius.only(topLeft: Radius.circular(30),bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)):
            BorderRadius.only(topRight: Radius.circular(30),bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
            elevation: 5.0,
            color: isMe? Colors.lightGreen[100] : Colors.lightGreen[800],
            child: Padding(
              padding: EdgeInsets.symmetric(vertical : 10.0 , horizontal: 20.0),
              child: Text(
                  text,
                  style : TextStyle(
                    color: isMe? Colors.black: Colors.white,
                    fontSize: 15,
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }
}


