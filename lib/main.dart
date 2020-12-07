import 'package:lilly_app/Screens/EditSubcat.dart';
import 'package:lilly_app/mockData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lilly_app/Screens/AddProduct.dart';
import 'package:lilly_app/Screens/homePage.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: EditSubcat.id,
      routes: {
        AddProduct.id : (context) => AddProduct(),
        homePage.id : (context) => homePage(),
        EditSubcat.id : (context) => EditSubcat(),
      },
    );
  }
}

