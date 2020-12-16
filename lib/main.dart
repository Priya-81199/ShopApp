import 'package:lilly_app/Screens/AddPhtotos.dart';
import 'package:lilly_app/Screens/EditSubcat.dart';
import 'package:lilly_app/Screens/new_mock_data.dart';
import 'package:lilly_app/Screens/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lilly_app/Screens/addProduct.dart';
import 'package:lilly_app/Screens/ProductList.dart';
import 'package:lilly_app/Screens/homePage.dart';
import 'package:lilly_app/Screens/login.dart';
import 'package:lilly_app/Screens/register.dart';
import 'package:lilly_app/Screens/send_receive.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AddPhotos.id,
      routes: {
        AddProduct.id : (context) => AddProduct(),
        homePage.id : (context) => homePage(),
        EditSubcat.id : (context) => EditSubcat(),
        LoginScreen.id : (context) => LoginScreen(),
        WelcomeScreen.id :(context) => WelcomeScreen(),
        RegistrationScreen.id :(context) => RegistrationScreen(),
        SendReceive.id :(context) => SendReceive(),
        MockData.id : (context) => MockData(),
        ProductList.id : (context) => ProductList(),
        AddPhotos.id : (context) => AddPhotos(),
      },
    );
  }
}

