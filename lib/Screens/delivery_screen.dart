import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:lilly_app/Screens/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lilly_app/app/route.gr.dart';

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
  bool isNewAddress = false;

  @override
  void initState() {
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

    List<Widget> deliveryCards = [];

    if (deliveryAddressesFetched) {
      for (var i = 0; i < deliveryAddresses.length; i++) {
        var addressDetails = deliveryAddresses[i];
        var address = addressDetails['address'];
        var fullAddress = '';
        for (var i = 0; i < address.length; i++) {
          if (i != 0) {
            fullAddress += ',\n';
          }
          fullAddress += address[i];
        }
        deliveryCards.add(Column(
          children: [
            FlatButton(
              hoverColor: Colors.transparent,
              onPressed: () {
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
                decoration: BoxDecoration(
                    color: Color.fromRGBO(39, 102, 120, 0.2),
                    border: Border.all(),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        addressDetails['name'],
                        style: TextStyle(
                          fontFamily: 'RocknRoll',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        addressDetails['phone'],
                        style: TextStyle(
                          fontFamily: 'RocknRoll',
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        fullAddress,
                        style: TextStyle(
                          fontFamily: 'Handlee',
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ));
      }
    }

    return Scaffold(
      appBar: buildAppBar(context, f),
      body: Center(
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Saved Addresses(${deliveryCards.length})',
                    style: TextStyle(fontFamily: 'Lobster', fontSize: 20),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: deliveryCards,
                    ),
                  ),
                ],
              ),
              Container(
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
                        onChanged: (value) {
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
                        onChanged: (value) {
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
                        onChanged: (value) {
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
                        onChanged: (value) {
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
                        onChanged: (value) {
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
                        onChanged: (value) {
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
                        onChanged: (value) {
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
                          if (isNewAddress) saveAddress();
                          placeOrder();
                          ExtendedNavigator.of(context)
                              .popAndPush(Routes.homePage);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  placeOrder() async {
    final name = myController1.text;
    final phone = myController2.text;
    final address = [
      myController4.text,
      myController5.text,
      myController6.text,
      myController7.text,
      myController3.text
    ];
    var session = FlutterSession();
    var products = await session.get('argument_prod');
    products = products['product'];
    print(products);
    for (var i = 0; i < products.length; i++) {
      _firestore.collection('order_details').add({
        'name': name,
        'phone': phone,
        'address': address,
        'email': loggedInUser.email,
        'Timestamp': FieldValue.serverTimestamp(),
        'DeliveryTime': null,
        'DeliveryStatus': 1,
        'PaymentMode': 'COD',
        'product': products[i],
        'IsPaid': false,
      });
      _firestore.collection('cart').doc(products[i]['cartID']).delete();
      var sizeType = products[i]['selectedSizeType'];
      var count = sizeType + 'Counts';
      var index = products[i]['selectedSizeIndex'];
      products[i][count][index] =
          (int.parse(products[i][count][index]) - 1).toString();
      var productID = products[i]['id'];
      _firestore
          .collection('productDetails')
          .doc(productID)
          .update(products[i]);
    }
  }

  saveAddress() async {
    final name = myController1.text;
    final phone = myController2.text;
    final address = [
      myController4.text,
      myController5.text,
      myController6.text,
      myController7.text,
      myController3.text
    ];

    await _firestore.collection('delivery_details').add({
      'name': name,
      'phone': phone,
      'address': address,
      'email': loggedInUser.email,
      'Timestamp': FieldValue.serverTimestamp(),
    });
  }

  getAddress() async {
    final user = await _auth.currentUser;
    final email = user.email;
    var fetchDeliveryAddress = [];
    await _firestore.collection('delivery_details').get().then((value) {
      var requiredLength = value.docs.length;
      value.docs.forEach((result) {
        if (email == result['email']) {
          var deliveryAddress = result.data();
          deliveryAddress['id'] = result.id;
          fetchDeliveryAddress.add(deliveryAddress);
        } else {
          requiredLength--;
        }
        if (requiredLength == fetchDeliveryAddress.length) {
          setState(() {
            deliveryAddressesFetched = true;
            deliveryAddresses = fetchDeliveryAddress;
          });
        }
      });
    });
  }
}
