import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_session/flutter_session.dart';
import 'app/route.gr.dart' as rg;

bool isUserSet = false;

class Data {
  final List<dynamic> productDetails;
  Data({
    this.productDetails,
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["productDetails"] = productDetails;
    return data;
  }
}

Future<List<dynamic>> getProductsDetails() async {
  Firebase.initializeApp();
  final db = FirebaseFirestore.instance;
  List<dynamic> productsDetails = [];
  await db.collection('productDetails').get().then((value) {
    value.docs.forEach((result) {
      var product = result.data();
      product['id'] = result.id;
      productsDetails.add(product);
    });
  });
  return productsDetails;
}

void main() async {
  var session = FlutterSession();
  bool isUserSet = await session.get("isUserSet");
  if (isUserSet != false && isUserSet != true)
    await session.set("isUserSet", false);
  // var prod_session = await session.get('prod_details');
  // if(prod_session==null)
   getProds();
  //setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

void getProds() async{
  var session = FlutterSession();
  session.set("prod_details", Data(productDetails: await getProductsDetails()));

}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), getProds);

    return MaterialApp(
      builder: ExtendedNavigator.builder<rg.Router>(
        router: rg.Router(),
        //initialRoute: rg.Routes.introPage,
        builder: (context, navigator) => Theme(
          data: ThemeData.light(),
          child: navigator,
        ),
      ),
      debugShowCheckedModeBanner: false,
      //AddProducts.id,
      //routes: {
      //   AddProduct.id : (context) => AddProduct(),
      //   homePage.id : (context) => homePage(),
      //   EditSubcat.id : (context) => EditSubcat(),
      //   LoginScreen.id : (context) => LoginScreen(),
      //   WelcomeScreen.id :(context) => WelcomeScreen(),
      //   RegistrationScreen.id :(context) => RegistrationScreen(),
      //   SendReceive.id :(context) => SendReceive(),
      //   MockData.id : (context) => MockData(),
      //   ProductList.id : (context) => ProductList(),
      //   AddPhotos.id : (context) => AddPhotos(),
      //   AddProducts.id : (context) => AddProducts(),
      //   ProductDetails.id : (context) => ProductDetails(),
      //},
      onGenerateRoute: rg.Router(),

      //navigatorKey: locator<NavigationService>().navigatorKey,
    );
  }
}
