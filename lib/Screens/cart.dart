import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lilly_app/app/route.gr.dart';

final db = FirebaseFirestore.instance;

class Cart extends StatefulWidget {
  static const String id = "Cart";
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String user = '';
  //String user = 'priya81199@gmail.com';

  bool isCartFetched = false;

  var totalDetails;
  List<dynamic> cartDetails = [];
  void getCartDetails() async {
    var cart = await db.collection('cart').get();
    var cartLen = cart.docs.length;
    cart.docs.forEach((result) {
      var product;
      totalDetails = result.data();
      product = totalDetails['product'];

      product['image'] = getImageURL(product['images'][0]);
      product['cartID'] = result.id;
      if (_auth.currentUser != null) {
        user = FirebaseAuth.instance.currentUser.email;
      }
      if (user == totalDetails['user']) {
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
    await session.set("last_visited", Routes.cart);
  }

  void viewProduct(dynamic product) {
    ExtendedNavigator.of(context).push(
      Routes.productDetails,
      arguments: ProductDetailsArguments(product: product),
    );
  }

  void removeProduct(dynamic product) {
    db.collection('cart')
    .doc(product['cartID'])
    .delete()
    .then((value) => {
      setState(() {
        cartDetails.remove(product);
      }),
    });
  }

  @override
  Widget build(BuildContext context) {
    void f() {
      setState(() {});
    }

    List<TableRow> cartContent = [];
    cartContent.add(
      TableRow(
        children: [
          Text(''),
          Text('Details'),
          Text('Actions'),
        ],
      ),
    );

    if (isCartFetched) {
      print(cartDetails);
      cartDetails.forEach((product) {
        cartContent.add(
          TableRow(
            children: [
              Container(
                  color: Colors.blue,
                  height: 200,
                  width: 200,
                  child: Image.network(product['image']),
              ),
              Container(
                child: Column(
                  children: [
                    Text(product['name']),
                    Text(product['description']),
                    Text(product['price']),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    FlatButton(
                      child: Icon(
                        Icons.remove_red_eye,
                        color: Colors.lightGreen,
                      ),
                      onPressed: () {
                        viewProduct(product);
                      },
                    ),
                    FlatButton(
                      child: Icon(
                        Icons.delete,
                        color: Colors.pink,
                      ),
                      onPressed: () {
                        removeProduct(product);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
    }

    return Scaffold(
      appBar: buildAppBar(context, f),
      body: SingleChildScrollView(
        child: Container(
          child: Table(
            children: cartContent,
          ),
        ),
      ),
    );
  }
}
