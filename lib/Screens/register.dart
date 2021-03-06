import 'package:auto_route/auto_route.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:flutter/material.dart';
import 'package:lilly_app/Screens/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lilly_app/Screens/homePage.dart';
import 'package:lilly_app/Screens/welcome.dart';
import 'package:lilly_app/app/route.gr.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/bg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: ListView(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: 200.0,
                  child: Image.asset('images/avatar.png'),
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
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
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
                          textAlign: TextAlign.center,
                          obscureText: true,
                          onChanged: (value) {
                            password = value;
                          },
                          decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Enter your password')),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    RoundedButton(
                      title: 'Register',
                      colour: Colors.indigo,
                      tag: 'register',
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });

                        print(email);
                        print(password);
                        try {
                          final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                          User user = FirebaseAuth.instance.currentUser;
                          if (!user.emailVerified) {
                            await user.sendEmailVerification();
                          }
                          if (newUser != null /*&& user.emailVerified*/) {
                            ExtendedNavigator.of(context).popAndPush(Routes.welcomeScreen);
                          }
                          // else if(){
                          //
                          // }
                          setState(() {
                            showSpinner = false;
                          });
                        } catch (e) {
                          print(e);
                          final snackBar = SnackBar(
                            content: Text(e.toString()),
                          );
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackBar);
                          setState(() {
                            showSpinner = false;
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      child: Text(
                        "Already a user? Login here.",
                        style: TextStyle(
                          color: Colors.indigoAccent,
                          fontFamily: 'Handlee',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onTap: (){
                        ExtendedNavigator.of(context).push(Routes.loginScreen);
                      },
                    )
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
