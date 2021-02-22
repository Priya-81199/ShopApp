import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lilly_app/app/route.gr.dart';

final db = FirebaseFirestore.instance;

class AdminOrders extends StatefulWidget {
  static const String id = "AdminOrders";
  @override
  _AdminOrdersState createState() => _AdminOrdersState();
}

class _AdminOrdersState extends State<AdminOrders> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String user = '';
  //String user = 'priya81199@gmail.com';

  bool isCartFetched = false;

  var totalDetails;
  List<dynamic> cartDetails = [];
  void getCartDetails() async {
    cartDetails=[];
    var cart = await db.collection('order_details').get();
    var cartLen = cart.docs.length;
    cart.docs.forEach((result) {
      var product;
      totalDetails = result.data();
      product = totalDetails['product'];

      product['image'] = getImageURL(product['images'][0]);
      product['ordersID'] = result.id;
      product['email'] = totalDetails['email'];
      product['Timestamp'] = totalDetails['Timestamp'];
      product['address'] = totalDetails['address'][0]+',\n' + totalDetails['address'][1]
          +',\n' + totalDetails['address'][2]+',\n' + totalDetails['address'][3]
          +'-' + totalDetails['address'][4];
      product['DeliveryStatus'] = totalDetails['DeliveryStatus'];
      if (_auth.currentUser != null) {
        user = FirebaseAuth.instance.currentUser.email;
      }
      if (user == adminEmail) {
        cartDetails.add(product);
      }

      if (cartLen == cartDetails.length) {
        setState(() {
          isCartFetched = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setLastVisited();
    getCartDetails();
  }

  void setLastVisited() async {
    var session = FlutterSession();
    await session.set("last_visited", Routes.adminOrders);
  }

  void viewProduct(dynamic product) {
    ExtendedNavigator.of(context).push(
      Routes.productDetails,
      arguments: ProductDetailsArguments(product: product),
    );
  }

  void updateDeliveryStatus(var status,dynamic docID,var index){
    db.collection('order_details')
        .doc(docID)
        .update({'DeliveryStatus': status})
        .then((value) => {
      setState(() {
        //getCartDetails();
        cartDetails[index]['DeliveryStatus'] = status;
      }),
    });
  }

  @override
  Widget build(BuildContext context) {
    void f() {
      setState(() {});
    }

    cartDetails.sort((b, a) => a['Timestamp'].compareTo(b['Timestamp']));


    List<TableRow> cartContent = [];


    if (isCartFetched) {
      //cartDetails.forEach((product)
      for(var i = 0; i < cartDetails.length ; i++){
        var product = cartDetails[i];
        cartContent.add(
          TableRow(
            children: [
              Container(
                //color: Colors.blue,
                height: 180,
                width: 180,
                child: Image.network(product['image']),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      product['email'],
                      style: TextStyle(
                          fontFamily: 'Lobster',
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                          color: Colors.pinkAccent
                      ),
                    ),
                    Text(
                      product['name'],
                      style: TextStyle(
                        fontFamily: 'Lobster',
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),

                    ),
                    Text(
                      product['description'],
                      style: TextStyle(
                        fontFamily: 'Handlee',
                        fontWeight: FontWeight.w200,
                        fontSize:20,
                      ),),
                    Text(
                      '₹' + product['price'],
                      style: TextStyle(
                          fontFamily: 'Lobster',
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                          color: Colors.pinkAccent
                      ),

                    ),
                  ],
                ),
              ),
              Container(
                child: Text(
                  product['address'],
                  style: TextStyle(
                    fontFamily: 'Handlee',
                    fontWeight: FontWeight.w200,
                    fontSize:20,
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    FlatButton(
                      color: product['DeliveryStatus']==0?Colors.green:Colors.transparent,
                      child: Text(
                        'Reject Order'
                      ),
                      onPressed: () {
                        updateDeliveryStatus(0,product['ordersID'],i);
                      },
                    ),
                    FlatButton(
                      color: product['DeliveryStatus']==2?Colors.green:Colors.transparent,
                      child: Text(
                        'In Transit'
                      ),
                      onPressed: () {
                        updateDeliveryStatus(2,product['ordersID'],i);
                      },
                    ),
                    FlatButton(
                      color: product['DeliveryStatus']==3?Colors.green:Colors.transparent,
                      child: Text(
                          'Order Delivered'
                      ),
                      onPressed: () {
                        updateDeliveryStatus(3,product['ordersID'],i);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
        cartContent.add(
          TableRow(
            children: [
              SizedBox(height: 20,),
              SizedBox(height: 20,),
              SizedBox(height: 20,),
              SizedBox(height: 20,),
            ],
          ),
        );

      }
    }

    return Scaffold(
      appBar: buildAppBar(context, f),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Container(
              child: Text(
                'My Orders (${cartDetails.length.toString()})',
                style: TextStyle(
                    fontFamily: 'Handlee',
                    fontSize: 30,
                    color: Colors.blueGrey
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              child: Table(
                children: cartContent,
              ),
            ),
          ],
        ),
      ),

    );
  }
}
