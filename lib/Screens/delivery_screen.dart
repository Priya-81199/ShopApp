import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:lilly_app/Screens/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = FirebaseFirestore.instance;

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
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  List<dynamic> deliveryAddresses = [];
  bool deliveryAddressesFetched = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getAddress();
  }

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
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
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
    List<Widget> deliveryCards=[];

    if(deliveryAddressesFetched){
      for(var i = 0; i < deliveryAddresses.length ; i++){
        var addressDetails = deliveryAddresses[i];
        var address = addressDetails['address'];
        var fullAddress = '';
        for(var i = 0 ; i < address.length ; i++){
          if(i!=0){
            fullAddress += ',';
          }
          fullAddress += address[i];
        }
        deliveryCards.add(
          Container(
            child: Column(
              children: [
                Text(addressDetails['name']),
                Text(addressDetails['phone']),
                Text(fullAddress),
              ],
            ),
          )
        );
      }

    }

    return Scaffold(
      appBar: buildAppBar(context, f),
      body: Center(
        child: Container(
          child: SizedBox(
            width: 400,
            child: Column(
              children: [
                Row(
                  children: deliveryCards,
                ),
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
                    labelText: 'Landmark',
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
                RoundedButton(
                  title: 'Deliver Here!',
                  colour: Colors.indigo,
                  tag: 'register',
                  onPressed: () {
                    saveAddress();
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
  saveAddress() async{
    final name = myController1.text;
    final phone = myController2.text;
    final address =  [myController4.text, myController5.text , myController6.text,myController7.text, myController3.text] ;

    await  _firestore.collection('delivery_details').add({
      'name': name,
      'phone': phone,
      'address': address,
      'email': loggedInUser.email,
      'Timestamp': FieldValue.serverTimestamp(),
    });
  }

  getAddress() async{
    final user = await _auth.currentUser;
    final email = user.email;
    var fetchDeliveryAddress = [];
    await _firestore.collection('delivery_details').get().then((value) {
      var requiredLength = value.docs.length;
      value.docs.forEach((result) {
         if(email == result['email']){
           var deliveryAddress = result.data();
           deliveryAddress['id'] = result.id;
           fetchDeliveryAddress.add(deliveryAddress);
         }
         else{
           requiredLength--;
         }
         if(requiredLength==fetchDeliveryAddress.length){
           setState(() {
             deliveryAddressesFetched = true;
             deliveryAddresses = fetchDeliveryAddress;
           });
         }
      });
    });
  }
}
