import 'package:flutter/material.dart';


AppBar buildAppBar(BuildContext context) {
  return AppBar(
    automaticallyImplyLeading: false,
    toolbarOpacity: 0.7,
    backgroundColor: Colors.indigo,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Text(
            "Lilly Shop"
        ),
        Hero(
          tag: 'user',
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://cdn3.iconfinder.com/data/icons/avatars-round-flat/33/avat-01-512.png'),
            radius: 20,
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
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.indigoAccent, width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintStyle: TextStyle(
      color: Colors.indigo
  ),
  hintText: 'Enter a value',
  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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