import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:lilly_app/app/route.gr.dart';

class AdminPortal extends StatefulWidget {
  static const String id = 'AdminPortal';
  @override
  _AdminPortalState createState() => _AdminPortalState();
}


class _AdminPortalState extends State<AdminPortal> {

    User loggedInUser = FirebaseAuth.instance.currentUser;
    @override
    void initState(){
      super.initState();
      setLastVisited();
      getCurrentUser();
    }
    void setLastVisited() async {
      var session = FlutterSession();
      await session.set("last_visited", Routes.adminPortal);
    }


    void getCurrentUser() async {
      try{
        final user = await FirebaseAuth.instance.currentUser;
        if (user != null) {
          if(user.email == adminEmail){
            loggedInUser = user;
          }
          else{
            ExtendedNavigator.of(context).popAndPush(Routes.homePage);
          }
        }
        else{
          ExtendedNavigator.of(context).popAndPush(Routes.welcomeScreen);
        }
      } catch (e) {
        print(e);
      }
    }


  @override
  Widget build(BuildContext context) {
    void f() {
      setState(() {});
    }

    return Scaffold(
      appBar: buildAppBar(context, f),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 50,
              crossAxisSpacing: 50,
            children: [
              FlatButton(
                hoverColor: Colors.black38,
                color: Color.fromRGBO(39, 102, 120, 0.8),
                onPressed: (){
                  ExtendedNavigator.of(context).push(Routes.adminProductList);
                },
                child: Container(
                  child:Text(
                    'All Products',
                    style: TextStyle(
                      fontFamily: 'RocknRoll',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  )
                ),
              ),
              FlatButton(
                hoverColor: Colors.black38,
                color: Color.fromRGBO(39, 102, 120, 0.8),
                onPressed: (){
                  ExtendedNavigator.of(context).push(Routes.solveQueries);
                },
                child: Container(
                    child:Text(
                      'Customer Chat',
                      style: TextStyle(
                          fontFamily: 'RocknRoll',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    )
                ),
              ),
              FlatButton(
                hoverColor: Colors.black38,
                color: Color.fromRGBO(39, 102, 120, 0.8),
                onPressed: (){
                  ExtendedNavigator.of(context).push(Routes.adminOrders);
                },
                child: Container(
                    child:Text(
                      'All Orders',
                      style: TextStyle(
                          fontFamily: 'RocknRoll',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    )
                ),
              ),
              FlatButton(
                hoverColor: Colors.black38,
                color: Color.fromRGBO(39, 102, 120, 0.8),
                onPressed: (){
                  ExtendedNavigator.of(context).push(Routes.addProductsDetails);
                },
                child: Container(
                    child:Text(
                      'Add New Product',
                      style: TextStyle(
                          fontFamily: 'RocknRoll',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    )
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}