import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:lilly_app/Screens/rounded_button.dart';
import 'package:lilly_app/app/route.gr.dart';

class IntroPage extends StatefulWidget {

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {

  @override
  Widget build(BuildContext context) {
    void f() {
      setState(() {});
    }

    return Scaffold(
      appBar: buildAppBar(context, f),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops:[0.5,1],
                colors:[Color.fromRGBO(39, 102, 120, 1),Color.fromRGBO(211, 224, 234, 1)],
              )
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 800,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text("Our story in fashion retail industry began in 1986. "
                      "From the very beginning our vision was not just to sell products and earn money but to serve our customers with latest trends and fashion with quality products at reasonable price."
                      "We are happy to introduce our online store to serve our customers even more",
                    style: TextStyle(fontSize: 36.0,color: Colors.white,fontFamily: 'AT'),),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: RoundedButton(
                title: 'Continue to website',
                colour: Color.fromRGBO(39, 102, 120, 1),
                tag: 'login',
                onPressed: (){
                  ExtendedNavigator.of(context).push(Routes.homePage);
                },
                ),
          ),
        ],
      ),
    );
  }
}
