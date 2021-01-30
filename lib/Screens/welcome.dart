import 'package:flutter/material.dart';
import 'package:lilly_app/Screens/rounded_button.dart';
import 'package:lilly_app/Screens/login.dart';
import 'package:lilly_app/Screens/register.dart';
import 'package:lilly_app/app/route.gr.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:url_launcher/url_launcher.dart';


class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin{

  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = ColorTween(begin: Colors.blueGrey , end: Colors.white).animate(controller);

    controller.forward();

    controller.addListener((){
      setState(() {});
    });
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(

      backgroundColor: animation.value,
      body:  Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/avatar.png'),
                      height: 300.0,
                    ),
                  ),
                  Flexible(
                    child:
                      Text( 'Lilly Shop',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.w900,
                      ),
                  ),
                  ),
                ],
              ),
              SizedBox(
                height: 48.0,
              ),
              Column(
                children: [

                  RoundedButton(title: 'Log in',colour: Colors.indigoAccent,tag: 'login', onPressed: () {
                    Navigator.push(
                        context, new MaterialPageRoute(builder: (BuildContext context) => new LoginScreen())
                    );
                  },),
                  RoundedButton(title: 'Register',colour: Colors.indigo, tag : 'register',onPressed: () {
                    Navigator.push(
                        context, new MaterialPageRoute(builder: (BuildContext context) => new RegistrationScreen())
                    );
                  },),
                ],
              ),

            ],
          ),
        ),

      ),
    floatingActionButton: FloatingActionButton(
      child: Icon(
        Icons.message_rounded
      ),
      onPressed: launchWhatsApp,
    ),
    );
  }
  launchWhatsApp() async {
    final link = WhatsAppUnilink(
      phoneNumber: '+91-9699893233',
      text: "Hey!",
    );
    // Convert the WhatsAppUnilink instance to a string.
    // Use either Dart's string interpolation or the toString() method.
    // The "launch" method is part of "url_launcher".
    await launch('$link');
  }
}

