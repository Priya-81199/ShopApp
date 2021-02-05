import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:lilly_app/app/route.gr.dart' as rg;
import 'homePage.dart';
import 'login.dart';

String getImageURL(String imageName) {
  return 'https://firebasestorage.googleapis.com/v0/b/lillyapp-d0f89.appspot.com/o/product_images%2F${imageName}?alt=media';
}

String adminEmail = 'princymishra10@gmail.com';

AppBar buildAppBar(BuildContext context,Function() f) {
  return AppBar(
    backgroundColor: Color.fromRGBO(39, 102, 120, 1),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Center(
          child: Text(
            'Lilly',
            style: TextStyle(
              fontFamily: 'Lobster',
              fontSize: 40,
            ),
          ),
        ),
        Container(
          child: FutureBuilder(
            future: FlutterSession().get('isUserSet'),
            builder: (context, snapshot) {
              return Container(
                width: 150,
                height: 100,
                child: FlatButton(
                  hoverColor: Color.fromRGBO(211, 224, 234, 1),
                  child: Text(
                    snapshot.hasData
                        ? (snapshot.data ? 'Logout' : 'Login')
                        : 'Loading',
                    style: TextStyle(
                      fontFamily: 'Lobster',
                      fontSize: 24,
                    ),
                  ),
                  onPressed: () async {
                    //print(snapshot.data);
                    if (snapshot.hasData) {
                      if (snapshot.data) {
                        FirebaseAuth.instance.signOut();
                        await FlutterSession().set('isUserSet', false);
                        f();
                        //ExtendedNavigator.root.push(rg.Routes.homePage);
                      } else {
                        //Navigator.pushNamed(context, rg.Routes.);
                        ExtendedNavigator.of(context).push(rg.Routes.loginScreen);
                      }
                    }
                  },
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
