import 'package:flutter/material.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:lilly_app/Screens/rounded_button.dart';

class DeliveryScreen extends StatefulWidget {
  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final numOfFeilds = 7;
  var labelTexts = ['Full Name', 'Mobile Number','PIN Code','Address Line 1','Address Line 2','Address Line 3', 'Town/City'];
  var cuompulsaryFeilds = [true, true, true, true, false, false, true];
  final myControllers = List.filled(7, TextEditingController());

  @override
  void dispose() {
    for(var i=0 ;i<numOfFeilds; i++)
      myControllers[i].dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void f() {
      setState(() {});
    }

    List<Widget> body = [];
    body.add(SizedBox(
      height: 30,
    ));
    body.add(Text(
      'Enter a shipping address',
      style: TextStyle(fontFamily: 'Lobster', fontSize: 20),
    ));
    body.add(SizedBox(
      height: 30,
    ));
    for(var i = 0 ; i<numOfFeilds; i++) {
      body.add(
        TextField(
          controller: myControllers[i],
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: labelTexts[i],
          ),
        ),
      );
      body.add(SizedBox(
        height: 10,
      ));
    }
    body.add(
      RoundedButton(
        title: 'Deliver Here!',
        colour: Colors.indigo,
        tag: 'register',
        onPressed: () {
          for(var i=0; i<numOfFeilds; i++)
            print(myControllers[i].text);
        },
      ),
    );

    return Scaffold(
      appBar: buildAppBar(context, f),
      body: Center(
        child: Container(
          child: SizedBox(
            width: 400,
            child: Column(
              children: body,
            ),
          ),
        ),
      ),
    );
  }
}
