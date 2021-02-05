import 'package:flutter/material.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:lilly_app/Screens/rounded_button.dart';
import 'package:lilly_app/Screens/welcome.dart';

class DeliveryScreen extends StatefulWidget {
  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();
  final myController4 = TextEditingController();
  final myController5 = TextEditingController();
  final myController6 = TextEditingController();
  final myController7 = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController1.dispose();
    myController2.dispose();
    myController3.dispose();
    myController4.dispose();
    myController5.dispose();
    myController6.dispose();
    myController7.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void f() {
      setState(() {});
    }

    return Scaffold(
      appBar: buildAppBar(context, f),
      body: Center(
        child: Container(
          child: SizedBox(
            width: 400,
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Enter a shipping address',
                  style: TextStyle(fontFamily: 'Lobster', fontSize: 20),
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: myController1,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Full Name',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: myController2,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mobile Number',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: myController3,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'PIN Code',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: myController4,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address Line 1',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: myController5,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address Line 2',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: myController6,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address Line 3',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: myController7,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Town/City',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RoundedButton(
                  title: 'Deliver Here!',
                  colour: Colors.indigo,
                  tag: 'register',
                  onPressed: () {
                    // Navigator.push(
                    //     context, new MaterialPageRoute(builder: (BuildContext context) => new WelcomeScreen())
                    // );
                    print(myController1.text);
                    print(myController2.text);
                    print(myController3.text);
                    print(myController4.text);
                    print(myController5.text);
                    print(myController6.text);
                    print(myController7.text);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
