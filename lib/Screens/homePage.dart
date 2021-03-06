import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:lilly_app/app/route.gr.dart';
import 'package:lilly_app/mockData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:flutter_session/flutter_session.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:scroll_to_id/scroll_to_id.dart';

final scrollController = ScrollController();

ScrollToId scrollToId = ScrollToId(scrollController: scrollController);

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

class homePage extends StatefulWidget {
  static const String id = "homePage";
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final messageTextController = TextEditingController();
  final scrollImages = ScrollController();
  bool newArrivalFetched = false;
  List<dynamic> newArrivalProducts = [];
  final dataKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    setLastVisited();
    getCurrentUser();
  }

  void setArrivalProducts() async {
    var session = FlutterSession();
    var details = await session.get("prod_details");
    details = details['productDetails'];
    var requiredLength = details.length;
    newArrivalProducts = [];
    for (var i = 0; i < details.length; i++) {
      if (details[i]['category'] == selectedCategory) {
        newArrivalProducts.add(details[i]);
      } else {
        requiredLength--;
      }
      if (requiredLength == newArrivalProducts.length) {
        setState(() {
          newArrivalFetched = true;
        });
      }
    }
  }

  void setLastVisited() async {
    var session = FlutterSession();
    await session.set("last_visited", Routes.homePage);
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

  List<Map<dynamic, dynamic>> products = [];

  void getData(String collection) async {
    await _firestore.collection(collection).get().then((value) {
      value.docs.forEach((result) {
        if (collection == 'products') products.add(result.data());
      });
    });
  }

  _homePageState() {
    getData('products');
  }

  var selectedCategory = 'Kids';
  @override
  Widget build(BuildContext context) {
    void f() {
      setState(() {});
    }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    setArrivalProducts();
    List<Widget> newArrivalProds = [];
    if (newArrivalFetched) {
      for (var i = 0; i < newArrivalProducts.length; i++) {
        newArrivalProds.add(getCard(context, newArrivalProducts[i], 300, 400));
      }
    }

    var category = <Widget>[];
    categories.sort((a, b) => a['name'].compareTo(b['name']));

    for (var i = 0; i < categories.length; i++) {
      category.add(
        FlatButton(
          onPressed: () {
            setState(() {
              selectedCategory = categories[i]['name'];
              Scrollable.ensureVisible(dataKey.currentContext);
            });
          },
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.asset('images/' + categories[i]['image']),
            ),
          ),
        ),
      );
    }

    var subcategory = <Widget>[];
    subcategory.add(
      SizedBox(width: 5),
    );
    for (var i = 0; i < subcategories.length; i++) {
      if (subcategories[i]['category'] == selectedCategory) {
        subcategory.add(
          SizedBox(width: 5),
        );
        subcategory.add(
          FlatButton(
            hoverColor: Colors.transparent,
            onPressed: () async {
              var session = FlutterSession();
              await session.set("argument_subcat", subcategories[i]['name']);
              ExtendedNavigator.of(context).push(Routes.productList);
              // arguments: ProductListArguments(
              //     subcategory: subcategories[i]['name']));
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
    for (var i = 0; i < min(20, products.length); i++) {
      product.add(
        SizedBox(width: 5),
      );
      product.add(
        FlatButton(
          onPressed: () {},
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.asset('images/' + products[i]['images'][0]),
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

    return Scaffold(
      backgroundColor: Color(0xf6f5f5),
      appBar: buildAppBar(context, f),
      body: Stack(
        children: [
          Stack(
            children: [
              SafeArea(
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

                      // Text(
                      //   'Categories',
                      //   style: TextStyle(
                      //     fontFamily: 'Lobster',
                      //     fontSize: 30,
                      //     fontWeight: FontWeight.w700,
                      //   ),
                      // ),

                      Container(
                        color: Color.fromRGBO(211, 224, 234, 1),
                        child: width > height ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              hoverColor: Color.fromRGBO(246, 245, 245, 1),
                              onPressed: () {
                                selectCat('Gents');
                              },
                              child: Container(
                                width:width/5,
                                height: 70,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'Men Clothing',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Handlee',
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            FlatButton(
                              hoverColor: Color.fromRGBO(246, 245, 245, 1),
                              onPressed: () {
                                selectCat('Ladies');
                              },
                              child: Container(
                                width: width/5,
                                height: 70,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'Women Clothing',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Handlee',
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            FlatButton(
                              hoverColor: Color.fromRGBO(246, 245, 245, 1),
                              onPressed: () {
                                selectCat('Kids');
                              },
                              child: Container(
                                width: width/5,
                                height: 70,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'Kids Clothing',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Handlee',
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            FlatButton(
                              hoverColor: Color.fromRGBO(246, 245, 245, 1),
                              onPressed: () {
                                selectCat('Accessories');
                              },
                              child: Container(
                                width: width/5,
                                height: 70,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'Accessories',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Handlee',
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ):
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              hoverColor: Color.fromRGBO(246, 245, 245, 1),
                              onPressed: () {
                                selectCat('Gents');
                              },
                              child: Container(
                                width: width,
                                height: 70,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'Men Clothing',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Handlee',
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            FlatButton(
                              hoverColor: Color.fromRGBO(246, 245, 245, 1),
                              onPressed: () {
                                selectCat('Ladies');
                              },
                              child: Container(
                                width: width,
                                height: 70,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'Women Clothing',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Handlee',
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            FlatButton(
                              hoverColor: Color.fromRGBO(246, 245, 245, 1),
                              onPressed: () {
                                selectCat('Kids');
                              },
                              child: Container(
                                width: width,
                                height: 70,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'Kids Clothing',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Handlee',
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            FlatButton(
                              hoverColor: Color.fromRGBO(246, 245, 245, 1),
                              onPressed: () {
                                selectCat('Accessories');
                              },
                              child: Container(
                                width: width,
                                height: 70,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'Accessories',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Handlee',
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Color.fromRGBO(34, 40, 49, 1),
                        width: width,
                        height: height - 120,
                        child: CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            aspectRatio: 2.0,
                            enlargeCenterPage: true,
                            autoPlayAnimationDuration: Duration(seconds: 1),
                          ),
                          items: category,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      Text(
                        selectedCategory,
                        style: TextStyle(
                          fontFamily: 'Lobster',
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      Container(
                        key: dataKey,
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        height: 300.0,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                            onPressed: (){
                              scrollImages.animateTo(0, duration: Duration(seconds: 1), curve: Curves.easeIn);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.chevron_left_rounded,
                                ),
                                Icon(
                                    Icons.chevron_left_rounded
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'New Arrivals',
                            style: TextStyle(
                              fontFamily: 'Lobster',
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          FlatButton(
                            onPressed: (){
                              scrollImages.animateTo(20000, duration: Duration(seconds: 1), curve: Curves.easeIn);
                            },
                            child: Row(
                              children: [
                                Icon(
                                    Icons.chevron_right_rounded,
                                ),
                                Icon(
                                    Icons.chevron_right_rounded
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Container(
                      //   margin: EdgeInsets.symmetric(vertical: 20.0),
                      //   height: 120.0,
                      //   child: ListView(
                      //     scrollDirection: Axis.horizontal,
                      //     children: product,
                      //   ),
                      // ),

                      SizedBox(
                        height: 20,
                      ),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: scrollImages,
                        child: Row(
                          children: newArrivalProds,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void selectCat(String catName) {
    setState(() {
      selectedCategory = catName;
      newArrivalFetched = false;
      setArrivalProducts();
      Scrollable.ensureVisible(dataKey.currentContext);
    });
    // scrollToId.animateTo(
    //     'b',
    //     duration: Duration(milliseconds: 500),
    //     curve: Curves.ease
    // );
  }
}
