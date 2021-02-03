import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lilly_app/app/route.gr.dart';


FirebaseStorage storage = FirebaseStorage.instance;
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
  List<dynamic> CartDetails=[];
  void getCartDetails()  async{
    var cart = await db.collection('cart').get();
    var cart_len = cart.docs.length;
      cart.docs.forEach((result) {
        var product;
        totalDetails = result.data();
        product = totalDetails['product'];

        // storage.ref('product_images/' + product['images'][0])
        //     .getDownloadURL().then((value) {
          product['image'] = getImageURL(product['images'][0]);
          product['cartID'] = result.id;
          if(_auth.currentUser != null) {
            user = FirebaseAuth.instance.currentUser.email;
          }
          if(user == totalDetails['user']){
            CartDetails.add(product);
          }
          else{
            cart_len--;
          }

        //}).then((value) => {

          if(cart_len==CartDetails.length)  {
            setState(() {
              isCartFetched = true;
            });
          }
       // });

      });




  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCartDetails();

  }

  void viewProduct(dynamic product){
    ExtendedNavigator.of(context).push(Routes.productDetails,arguments: ProductDetailsArguments(product: product));

  }
  void removeProduct(dynamic product){
    db.collection('cart').doc(product['cartID']).delete().then((value) => {
      setState(() {
        CartDetails.remove(product);
      })
    });
  }

  @override
  Widget build(BuildContext context) {



    List<TableRow> cart_content = [];
    cart_content.add(
        TableRow(
        children: [
          Text(''),
          Text('Details'),
          Text('Actions'),
        ]
    ));

    if(isCartFetched){
      print(CartDetails);
      CartDetails.forEach((product) {
        cart_content.add(
            TableRow(
              children: [
               Container(
                 color: Colors.blue,
                 height: 200,
                   width: 200,
                   child: Image.network(product['image'])
               ),
                Container(
                  child: Column(
                    children:[
                      Text(product['name']),
                      Text(product['description']),
                      Text(product['price']),
                    ]
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
                )
                //Text(product['image'])
              ]
            )
        );
      });
    }


    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Container(
          child: Table(
            children: cart_content,
          )
        ),
      ),
    );
  }
}