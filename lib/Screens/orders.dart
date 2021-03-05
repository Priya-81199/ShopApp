import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lilly_app/app/route.gr.dart';

final db = FirebaseFirestore.instance;

class Orders extends StatefulWidget {
  static const String id = "Orders";
  @override
  _OrdersState createState() => _OrdersState();
}

class Data {
  final dynamic product;
  Data({
    this.product,
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["product"] = product;
    return data;
  }
}

class _OrdersState extends State<Orders> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String user = '';
  //String user = 'priya81199@gmail.com';

  bool isCartFetched = false;

  var totalDetails;
  List<dynamic> cartDetails = [];
  void getCartDetails() async {
    var cart = await db.collection('order_details').get();
    var cartLen = cart.docs.length;
    cart.docs.forEach((result) {
      var product;
      totalDetails = result.data();
      product = totalDetails['product'];

      product['image'] = getImageURL(product['images'][0]);
      product['cartID'] = result.id;
      product['Timestamp'] = totalDetails['Timestamp'];
      product['DeliveryStatus'] = totalDetails['DeliveryStatus'];
      if (_auth.currentUser != null) {
        user = FirebaseAuth.instance.currentUser.email;
      }
      if (user == totalDetails['email']) {
        cartDetails.add(product);
      } else {
        cartLen--;
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
    await session.set("last_visited", Routes.orders);
  }

  void viewProduct(dynamic product) async {
    print(product);
    product['Timestamp'] = '';
    var session = FlutterSession();
    await session.set("argument_prod", Data(product: product));
    ExtendedNavigator.of(context).push(Routes.productDetails);
    //   arguments: ProductDetailsArguments(product: product),
    // );
  }

  void removeProduct(dynamic product) {
    db.collection('cart').doc(product['cartID']).delete().then((value) => {
          setState(() {
            cartDetails.remove(product);
          }),
        });
  }

  String displayStatus(var status) {
    if (status == 0) {
      return 'Order Cancelled';
    } else if (status == 1) {
      return 'Order Placed';
    } else if (status == 2) {
      return 'Out for Delivery';
    } else if (status == 3) {
      return 'Order Received';
    }
  }

  @override
  Widget build(BuildContext context) {
    void f() {
      setState(() {});
    }

    cartDetails.sort((b, a) => a['Timestamp'].compareTo(b['Timestamp']));

    List<TableRow> cartContent = [];

    if (isCartFetched) {
      cartDetails.forEach((product) {
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
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '₹' + product['price'],
                      style: TextStyle(
                          fontFamily: 'Lobster',
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                          color: Colors.pinkAccent),
                    ),
                  ],
                ),
              ),
              Container(
                child: Tooltip(
                  message: 'View',
                  child: FlatButton(
                    child: Icon(
                      Icons.remove_red_eye,
                      color: Colors.lightGreen,
                    ),
                    onPressed: () {
                      viewProduct(product);
                    },
                  ),
                ),
              ),
              Container(
                child: Text(
                  displayStatus(product['DeliveryStatus']),
                  style: TextStyle(
                    fontFamily: 'Handlee',
                    fontWeight: FontWeight.w200,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        );
        cartContent.add(
          TableRow(
            children: [
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      });
    }

    return Scaffold(
      appBar: buildAppBar(context, f),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                        color: Colors.blueGrey),
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
        ],
      ),
    );
  }
}
