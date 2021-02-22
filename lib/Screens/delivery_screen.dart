import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:lilly_app/Screens/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lilly_app/app/route.gr.dart';

final _firestore = FirebaseFirestore.instance;

class DeliveryScreen extends StatefulWidget {
  final List<dynamic> products;
  DeliveryScreen(this.products);
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
  bool isNewAddress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getAddress();
    print(widget.products);
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
          FlatButton(
            onPressed: (){
              setState(() {
                myController4.text = address[0];
                myController5.text = address[1];
                myController6.text = address[2];
                myController7.text = address[3];
                myController3.text = address[4];
                myController1.text = addressDetails['name'];
                myController2.text = addressDetails['phone'];
                isNewAddress = false;
              });
            },
            child: Container(
              child: Column(
                children: [
                  Text(addressDetails['name']),
                  Text(addressDetails['phone']),
                  Text(fullAddress),
                ],
              ),
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
                  onChanged: (value){
                    setState(() {
                      isNewAddress = true;
                    });
                  },
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
                  onChanged: (value){
                    setState(() {
                      isNewAddress = true;
                    });
                  },
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
                  onChanged: (value){
                    setState(() {
                      isNewAddress = true;
                    });
                  },
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
                  onChanged: (value){
                    setState(() {
                      isNewAddress = true;
                    });
                  },
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
                  onChanged: (value){
                    setState(() {
                      isNewAddress = true;
                    });
                  },
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
                  onChanged: (value){
                    setState(() {
                      isNewAddress = true;
                    });
                  },
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
                  onChanged: (value){
                    setState(() {
                      isNewAddress = true;
                    });
                  },
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
                    if(isNewAddress)
                      saveAddress();
                    placeOrder();
                    ExtendedNavigator.of(context).popAndPush(Routes.homePage);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  placeOrder() async{
    final name = myController1.text;
    final phone = myController2.text;
    final address =  [myController4.text, myController5.text , myController6.text,myController7.text, myController3.text] ;
    final products = widget.products;
     for(var i =0; i < products.length ; i++ ) {
        _firestore.collection('order_details').add({
        'name': name,
        'phone': phone,
        'address': address,
        'email': loggedInUser.email,
        'Timestamp': FieldValue.serverTimestamp(),
        'DeliveryTime' : null,
        'DeliveryStatus' : 1,
        'PaymentMode':'COD',
        'product' : products[i],
        'IsPaid' : false,
      });
        _firestore.collection('cart').doc(products[i]['cartID']).delete();
    }


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
