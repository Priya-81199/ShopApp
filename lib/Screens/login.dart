import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:lilly_app/Screens/ProductDetails.dart';
import 'package:lilly_app/Screens/homePage.dart';
import 'package:lilly_app/Screens/rounded_button.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lilly_app/app/route.gr.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:lilly_app/main.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    void f() {
      setState(() {});
    }

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: ListView(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/avatar.png'),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 500,
                      child: TextField(
                        style: TextStyle(color: Colors.indigo),
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          //Do something with the user input.
                          email = value;
                        },
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter your email'),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    SizedBox(
                      width: 500,
                      child: TextField(
                        style: TextStyle(color: Colors.indigo),
                        obscureText: true,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          password = value;
                          //Do something with the user input.
                        },
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter your password'),
                      ),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    RoundedButton(
                        title: 'Log in',
                        colour: Colors.indigoAccent,
                        tag: 'login',
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            final user = await _auth.signInWithEmailAndPassword(
                                email: email, password: password);

                            User user1 = FirebaseAuth.instance.currentUser;

                            if (user != null && user1.emailVerified) {
                              //isUserSet=true;
                              var session = FlutterSession();
                              await session.set("isUserSet", true);
                              var lastVisited = await session.get('last_visited');
                              var arguments = await session.get('arguments');
                              if (lastVisited == Routes.productList) {
                                ExtendedNavigator.of(context).push(lastVisited,
                                    arguments: ProductListArguments(
                                        subcategory: arguments));
                              } else if (lastVisited == Routes.productDetails) {
                                ExtendedNavigator.of(context).push(lastVisited,
                                    arguments: ProductDetailsArguments(
                                        product: arguments['product']));
                              } else {
                                ExtendedNavigator.of(context).push(lastVisited);
                              }
                            }
                            setState(() {
                              showSpinner = false;
                            });
                          } catch (e) {
                            print(e);
                          }
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
