import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lilly_app/Screens/update_products.dart';
import 'package:lilly_app/app/route.gr.dart';

FirebaseStorage storage = FirebaseStorage.instance;
final db = FirebaseFirestore.instance;

class AdminProducts extends StatefulWidget {
  static const String id = "AdminProducts";
  @override
  _AdminProductsState createState() => _AdminProductsState();
}

class _AdminProductsState extends State<AdminProducts> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String user = '';
  //String user = adminEmail;
  var productsDetails = [];
  //var urls = [];
  bool image_set = false;

  Future<List<dynamic>> getData() async {
    var session = FlutterSession();
    var productsDetail = await session.get("prod_details");
    return productsDetail['productDetails'];
  }

  @override
  void initState() {
    super.initState();
    if (_auth.currentUser != null) {
      user = FirebaseAuth.instance.currentUser.email;
    }

    if (user == adminEmail) {
      getData().then((value) => value.forEach((result) {
            var len = value.length;

            // storage.ref('product_images/' + result['images'][0])
            //     .getDownloadURL()
            //     .then((value) {
            var prod_results = result;
            prod_results['url'] = getImageURL(result['images'][0]);
            productsDetails.add(prod_results);
            //urls.add(value);
            if (len == productsDetails.length) {
              setState(() {
                image_set = true;
              });
            }
            // });
          }));
    }
  }

  void viewProduct(dynamic product) {
    ExtendedNavigator.of(context).push(Routes.updateProducts,
        arguments: UpdateProductsArguments(product: product));
  }

  @override
  Widget build(BuildContext context) {
    List<TableRow> prod_content = [];
    prod_content.add(TableRow(children: [
      Text(''),
      Text('Details'),
      Text('Actions'),
    ]));
    // if(image_set) {
    //   print(productsDetails[0]);
    //   print(urls[0]);
    // }
    if (image_set) {
      productsDetails.forEach((product) {
        prod_content.add(TableRow(children: [
          Container(
              color: Colors.blue,
              height: 200,
              width: 200,
              child: Image.network(product['url'])),
          Container(
            child: Column(children: [
              Text(product['name']),
              Text(product['description']),
              Text(product['price']),
            ]),
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
              ],
            ),
          )
          //Text(product['image'])
        ]));
      });
    }

    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Container(
            child: Table(
          children: prod_content,
        )),
      ),
    );
  }
}
