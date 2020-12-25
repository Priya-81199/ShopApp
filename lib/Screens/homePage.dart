import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lilly_app/Screens/Components.dart';
//import 'package:lilly_app/mockData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';


class homePage extends StatefulWidget {

  static const String id = "homePage";
  @override
  _homePageState createState() => _homePageState();
}
final _firestore = FirebaseFirestore.instance;


class _homePageState extends State<homePage> {
  List<Map<dynamic, dynamic>> categories = [];
  List<Map<dynamic, dynamic>> subcategories = [];
  List<Map<dynamic, dynamic>> products = [];


  void getData(String collection) {

    _firestore.collection(collection).get().then((value) {

      value.docs.forEach((result) {
        if(collection == 'categories')
          categories.add(result.data());
        else if(collection == 'subcategories')
          subcategories.add(result.data());
        else if(collection == 'products')
          products.add(result.data());
      });
    });

  }
  _homePageState(){
    getData('categories');
    getData('subcategories');
    getData('products');
  }
  var selectedCategory = 'category 1';
  @override
  Widget build(BuildContext context) {

    var category = <Widget>[];
    categories.sort((a, b) => a['name'].compareTo(b['name']));
    var colour1 = [
      Colors.red.withOpacity(0.0),
      Colors.red.withOpacity(0.0),
    ];
    var colour2 = [
      Colors.black.withOpacity(0.5),
      Colors.black.withOpacity(0.5),
    ];
    var colour3 = [];
    category.add(
      SizedBox(width: 5),
    );
    for (var i = 0; i < categories.length; i++) {
      if(categories[i]['name']==selectedCategory) {
        colour3=colour1;
      }
      else {
        colour3=colour2;
      }

      category.add(
        SizedBox(width: 5),
      );
      category.add(
        GestureDetector(
          onTap: () {
              setState(() {
                selectedCategory = categories[i]['name'];
              });
              },

          child: Stack(
            children: <Widget>[
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.asset('images/' + categories[i]['image']),
                ),
              ),
              Container(
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.white,
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: colour3,
                    stops: [
                      0.0,
                      1.0
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      category.add(
          SizedBox(width: 5),
      );
    }
    category.add(
      SizedBox(width: 5),
    );


    var subcategory = <Widget>[];
    subcategory.add(
      SizedBox(width: 5),
    );
    for (var i = 0; i < subcategories.length; i++) {
      print(subcategories[i]);
      if(subcategories[i]['category'] == selectedCategory) {
        subcategory.add(
          SizedBox(width: 5),
        );
        subcategory.add(
          GestureDetector(
            onTap: () {
              print(subcategories[i]['name']);//TODO:route to productList with these params
            },
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Image.asset('images/' + subcategories[i]['image']),
              ),
            ),
          ),
        );
        subcategory.add(
          SizedBox(width: 5),
        );
      }
    }
    subcategory.add(
      SizedBox(width: 5),
    );


    var product = <Widget>[];
    products.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
    product.add(
      SizedBox(width: 5),
    );
    for (var i = 0; i < min(20,products.length); i++) {
      product.add(
        SizedBox(width: 5),
      );
      product.add(
        GestureDetector(
          onTap: () {
            print(products[i]['name']);
          },
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.asset('images/' + products[i]['images'][0]['image']),
            ),
          ),
        ),
      );
      product.add(
        SizedBox(width: 5),
      );
    }
    product.add(
      SizedBox(width: 5),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: buildAppBar(context),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     Container(
                //       width: 300,
                //       child: TextFormField(
                //         style: TextStyle(
                //           color: Colors.indigo.shade900,
                //           decorationColor: Colors.indigo.shade900
                //         ),
                //         decoration: InputDecoration(
                //           focusColor: Colors.indigo.shade900,
                //           labelText: 'Search',
                //           labelStyle: TextStyle(color: Colors.indigo.shade900),
                //         ),
                //       ),
                //     ),
                //     Icon(Icons.search),
                //   ],
                // ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  height: 120.0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(

                      children: category,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Sub Categories',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  height: 120.0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: subcategory,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'New Arivals',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  height: 120.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: product,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

