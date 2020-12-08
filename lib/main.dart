import 'package:lilly_app/Screens/EditSubcat.dart';
import 'package:lilly_app/Screens/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lilly_app/Screens/AddProduct.dart';
import 'package:lilly_app/Screens/homePage.dart';
import 'package:lilly_app/Screens/login.dart';
import 'package:lilly_app/Screens/register.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        AddProduct.id : (context) => AddProduct(),
        homePage.id : (context) => homePage(),
        EditSubcat.id : (context) => EditSubcat(),
        LoginScreen.id : (context) => LoginScreen(),
        WelcomeScreen.id :(context) => WelcomeScreen(),
        RegistrationScreen.id :(context) => RegistrationScreen(),

      },
    );
  }
}

