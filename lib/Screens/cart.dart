import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lilly_app/app/route.gr.dart';

final db = FirebaseFirestore.instance;


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

  void viewProduct(dynamic product) async{
    print(product);
    var session = FlutterSession();
    await session.set("argument_prod", Data(product:product));
    await ExtendedNavigator.of(context).push(Routes.productDetails);
    //   arguments: ProductDetailsArguments(product: product),
    // );
    print(product);
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


    if (isCartFetched) {
      cartDetails.forEach((product) {
        cartContent.add(
          TableRow(
            children: [
              FlatButton(
                hoverColor: Colors.transparent,
                onPressed: (){
                  viewProduct(product);
                },
                child: Container(
                    //color: Colors.blue,
                    height: 180,
                    width: 180,
                    child: Image.network(product['image']),
                ),
              ),
              FlatButton(
                hoverColor: Colors.transparent,
                onPressed: (){
                  viewProduct(product);
                },
                child: Container(
                  child: Column(
                    children: [
                      Align(
                        alignment:Alignment.centerLeft,
                        child: Text(
                          product['name'],
                          style: TextStyle(
                            fontFamily: 'Lobster',
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),

                        ),
                      ),
                      Align(
                        alignment:Alignment.centerLeft,
                        child: Text(
                          product['description'],
                          style: TextStyle(
                            fontFamily: 'Handlee',
                            fontWeight: FontWeight.w200,
                            fontSize:20,
                          ),),
                      ),
                      Align(
                        alignment:Alignment.centerLeft,
                        child: Text(
                          '₹' + product['price'],
                          style: TextStyle(
                              fontFamily: 'Lobster',
                              fontWeight: FontWeight.w300,
                              fontSize: 20,
                              color: Colors.pinkAccent
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Tooltip(
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
                    Tooltip(
                      message: 'Remove',
                      child: FlatButton(
                        child: Icon(
                          Icons.delete,
                          color: Colors.pink,
                        ),
                        onPressed: () {
                          removeProduct(product);
                        },
                      ),
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
                    'My Cart (${cartDetails.length.toString()})',
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
          // buildChatStack(f),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              onPressed: () async{
                print(cartDetails);
                var session = FlutterSession();
                await session.set("argument_prod", Data(product: cartDetails));
                ExtendedNavigator.of(context).push(Routes.deliveryScreen);
                    //arguments: DeliveryScreenArguments(products: cartDetails));
              },
              color: Colors.deepOrange,
              hoverColor:Colors.deepOrangeAccent,
              child: Container(
                height: 50,
                width: 170,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'PLACE ORDER',
                      style:TextStyle(
                        color: Color.fromRGBO(49,49,49,1),
                        fontSize: 18,
                      ),
                      //textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
