// import 'package:auto_route/auto_route.dart';
// import 'package:lilly_app/Screens/AddPhtotos.dart';
// import 'package:lilly_app/Screens/EditSubcat.dart';
// import 'package:lilly_app/Screens/ProductDetails.dart';
// import 'package:lilly_app/Screens/addProducts.dart';
// import 'package:lilly_app/Screens/new_mock_data.dart';
// import 'package:lilly_app/Screens/welcome.dart';
// import 'package:lilly_app/Screens/addProduct.dart';
// import 'package:lilly_app/Screens/ProductList.dart';
// import 'package:lilly_app/Screens/homePage.dart';
// import 'package:lilly_app/Screens/login.dart';
// import 'package:lilly_app/Screens/register.dart';
// import 'package:lilly_app/Screens/send_receive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lilly_app/app/locator.dart';
import 'package:lilly_app/app/route.gr.dart' as rg;
import 'package:lilly_app/services/storage_service.dart';
import 'package:stacked_services/stacked_services.dart';

void main() async{
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: rg.Routes.homePage,
                    //AddProducts.id,
      // routes: {
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
      // },
      onGenerateRoute: rg.Router(),
      navigatorKey: locator<NavigationService>().navigatorKey,
    );
  }
}

