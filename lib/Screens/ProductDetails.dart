import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import '../mockData.dart';
import 'Components.dart';
import 'package:lilly_app/app/route.gr.dart';

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

class ProductDetails extends StatefulWidget {
  static const String id = 'ProductDetails';
  final dynamic product;
  ProductDetails(this.product);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  var productIndex = 1;
  var selectedImageIndex = 0;
  var isImageZoomed = false;
  var size_default = 'L';
  bool similarProdFetched = false;
  List<dynamic> similarProducts = [];


  var urls = [];
  bool image_set = false;
  var products;
  @override
  void initState() {
    super.initState();
    products = widget.product;
    setLastVisited();
    setSimilarProducts();
    for (var i = 0; i < products['images'].length; i++) {
      urls.add(getImageURL(products['images'][i]));
      if (products['images'].length == urls.length) {
        setState(() {
          image_set = true;
        });
      }
    }
  }

  void setSimilarProducts() async{
    var session = FlutterSession();
    var details = await session.get("prod_details");
    details = details['productDetails'];
    var requiredLength = details.length;

    for(var i = 0 ; i < details.length ; i++){
      if(widget.product['subcategory']==details[i]['subcategory'] && widget.product['id']!=details[i]['id']){
          similarProducts.add(details[i]);
      }
      else{
        requiredLength--;
      }
      if(requiredLength==similarProducts.length){
        setState(() {
          similarProdFetched = true;
        });
      }
    }
  }

  void setLastVisited() async {
    var session = FlutterSession();
    await session.set("last_visited", Routes.productDetails);
    print(Routes.productDetails);
    await session.set("arguments", Data(product: widget.product));
    print(widget.product);
  }

  // getProductCard(dynamic product) {
  //
  //       return FlatButton(
  //         onPressed: () {
  //           ExtendedNavigator.of(context).push(Routes.productDetails,
  //               arguments: ProductDetailsArguments(product: product));
  //         },
  //         child: Container(
  //           padding: EdgeInsets.all(10.0),
  //           margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
  //           child: Column(
  //             children: [
  //               Container(
  //                   height: 200,
  //                   child: Image.network(getImageURL(product['images'][0]))),
  //               Align(
  //                 alignment: Alignment.topLeft,
  //                 child: Text(
  //                   product['name'],
  //                   style: TextStyle(
  //                     fontFamily: 'Lobster',
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //               Align(
  //                 alignment: Alignment.topLeft,
  //                 child: Text(
  //                   product['description'],
  //                   style: TextStyle(
  //                     fontFamily: 'Handlee',
  //                     fontSize: 14,
  //                   ),
  //                 ),
  //               ),
  //               Align(
  //                 alignment: Alignment.topLeft,
  //                 child: Text(
  //                   '₹' + product['price'],
  //                   style: TextStyle(
  //                     fontFamily: 'Lobster',
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w500,
  //                     color: Colors.pinkAccent,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //
  // }




  var selectedSize = -1;
  @override
  Widget build(BuildContext context) {
    void f() {
      setState(() {});
    }

    List<Widget> similarProds = [];

    if(similarProdFetched){
      for(var i = 0 ; i < similarProducts.length ; i++){
        similarProds.add(getCard(context,similarProducts[i],300,400));
      }
    }

    String getSizeCategory(String subcategory) {
      for (var i = 0; i < subcategories.length; i++) {
        if (subcategories[i]['name'] == subcategory)
          return subcategories[i]['size_category'];
      }
    }

    var image;
    if (urls.length > selectedImageIndex)
      image = urls[selectedImageIndex];
    else
      image =
      'https://www.bluechipexterminating.com/wp-content/uploads/2020/02/loading-gif-png-5.gif';
    List<Widget> images = [];
    List<Widget> displayProperty = [];
    var productName = products['name'];
    var productDetail = products['description'];
    var productPrice = products['price'];
    var productAddPoints = products['points'];
    //String addDetails = '';
    var sizes = (getSizeCategory(products['subcategory']) == 'size')
        ? products['sizeCounts']
        : (getSizeCategory(products['subcategory']) == 'age')
        ? products['ageCounts']
        : products['numberCounts'];
    List<bool> availableSizes = [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false
    ];
    List<Widget> sizeWidgets = [];

    List<String> sizeNames =
    (getSizeCategory(products['subcategory']) == 'size')
        ? ['4XS', '3XS', '2XS', 'XS', 'S', 'M', 'L', 'XL']
        : (getSizeCategory(products['subcategory']) == 'age')
        ? ['0-1', '2-3', '4-5', '6-7', '8-9', '10-11', '12-13']
        : [
      '12',
      '14',
      '16',
      '18',
      '20',
      '22',
      '24',
      '26',
      '28',
      '30',
      '32',
      '34',
      '36',
      '38',
      '40',
      '42'
    ];

    // for(int i = 0; i < productAddPoints.length;i++){
    //   addDetails = addDetails + productAddPoints[i];
    // }

    for (int i = 0; i < sizes.length; i++) {
      if (int.parse(sizes[i]) > 0) {
        availableSizes[i] = true;
      }
    }
    //print(availableSizes);
    images.add(
      SizedBox(width: 10),
    );

    for (var i = 0; i < sizeNames.length; i++) {
      if (availableSizes[i]) {
        sizeWidgets.add(
          FlatButton(
            onPressed: () {
              setState(() {
                selectedSize = i;
              });
            },
            child: Container(
              width: 60,
              height: 40,
              padding: EdgeInsets.all(5),
              child: Center(
                  child: Text(
                    sizeNames[i],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              decoration: BoxDecoration(
                color: (i == selectedSize)
                    ? Color.fromRGBO(22, 135, 167, 1)
                    : Color.fromRGBO(211, 224, 234, 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
            ),
          ),
        );
        sizeWidgets.add(
          SizedBox(
            width: 20,
          ),
        );
      }
    }
    for (var i = 0; i < products['images'].length; i++) {
      double paddingSize = 0;
      if (i == selectedImageIndex) paddingSize = 1;

      images.add(FlatButton(
          onPressed: () {
            setState(() {
              selectedImageIndex = i;
            });
          },
          child: urls.length > i
              ? Container(
            color: Colors.black,
            padding: EdgeInsets.all(paddingSize),
            child: Image.network(urls[i]),
          )
              : CircularProgressIndicator()));
      images.add(
        SizedBox(width: 10),
      );
    }

    for (var i = 0; i < products['properties'].length; i++) {
      displayProperty.add(
        Container(
          padding: EdgeInsets.all(5),
          child: Row(children: [
            Text(
              products['properties'][i]['name'] + ': ',
              style: TextStyle(
                fontFamily: 'Lobster',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              products['properties'][i]['value'],
              style: TextStyle(
                fontFamily: 'Handlee',
                fontSize: 20,
              ),
            )
          ]),
        ),
      );
    }
    for (var i = 0; i < products['points'].length; i++) {
      displayProperty.add(
        Container(
          padding: EdgeInsets.all(5),
          child: Row(children: [
            Text(
              products['points'][i],
              style: TextStyle(
                fontFamily: 'Handlee',
                fontSize: 20,
              ),
            )
          ]),
        ),
      );
    }
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: buildAppBar(context, f),
          body: Builder(
              builder: (BuildContext context) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    var width = constraints.maxWidth;
                    var height = constraints.maxHeight;
                    if (height < width)
                      return Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: width * 2 / 5,
                                      height: height,
                                      padding: EdgeInsets.all(height / 50),
                                      child: Column(
                                        children: [
                                          FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                isImageZoomed = true;
                                              });
                                            },
                                            child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxHeight: height * 17 / 20,
                                              ),
                                              child: Image.network(image),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxHeight: height / 15,
                                            ),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .center,
                                                children: images,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: width * 2 / 5,
                                      height: height,
                                      padding: EdgeInsets.fromLTRB(
                                          height / 50, height / 25, height / 50, 0),
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        //crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: width * 2 / 5,
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              productName,
                                              style: TextStyle(
                                                fontFamily: 'Lobster',
                                                fontWeight: FontWeight.bold,
                                                fontSize: height / 32,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              productDetail,
                                              style: TextStyle(
                                                fontFamily: 'Handlee',
                                                fontWeight: FontWeight.w200,
                                                fontSize: height / 40,
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            thickness: 1,
                                            color: Colors.grey,
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              '₹ $productPrice',
                                              style: TextStyle(
                                                  fontFamily: 'Lobster',
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: height / 40,
                                                  color: Colors.pinkAccent
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 40),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Properties',
                                              style: TextStyle(
                                                fontFamily: 'Lobster',
                                                fontWeight: FontWeight.bold,
                                                fontSize: height / 40,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                            child: Column(
                                              children: displayProperty,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          // Container(
                                          //   padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                          //   child: Column(
                                          //     children:[
                                          //       Text(addDetails),
                                          //     ]
                                          //   ),
                                          // ),
                                          SizedBox(height: 20),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Available ${getSizeCategory(
                                                  products['subcategory'])}',
                                              style: TextStyle(
                                                fontFamily: 'Lobster',
                                                fontWeight: FontWeight.bold,
                                                fontSize: height / 40,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: sizeWidgets,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Container(
                                            height: height * 0.20,
                                            width: width / 5,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(width: 1),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: width * 0.1,
                                                  height: height / 20,
                                                  margin: EdgeInsets.fromLTRB(
                                                      height / 32,
                                                      height / 32, height / 32,
                                                      height / 64),
                                                  padding: EdgeInsets.all(height / 100),
                                                  child: Center(
                                                    child: FutureBuilder(
                                                        future:
                                                        FlutterSession().get(
                                                            'isUserSet'),
                                                        builder: (context, snapshot) {
                                                          return FlatButton(
                                                            onPressed: () async{
                                                              final snackBar = SnackBar(
                                                                content: Text('Please Select ${getSizeCategory(products['subcategory'])}'),
                                                              );
                                                              if(snapshot.hasData && snapshot.data){
                                                                if(selectedSize == -1){
                                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                }
                                                                else{
                                                                  products['selectedSize'] =sizeNames[selectedSize];
                                                                  products['cartID'] = await addToCart();
                                                                  ExtendedNavigator.of(context).push(Routes.deliveryScreen,arguments: DeliveryScreenArguments(products: [products]));
                                                                }
                                                              }
                                                              else{
                                                                ExtendedNavigator.of(context).push(Routes.welcomeScreen);
                                                              }
                                                            },
                                                            child: Text(
                                                              'Buy Now',
                                                              style: TextStyle(
                                                                fontFamily: 'Lobster',
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        22, 135, 167, 1),
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(15),
                                                    ),
                                                  ),
                                                ),
                                                FlatButton(
                                                  onPressed: () {
                                                    var cartID;
                                                    if (_auth.currentUser != null) {
                                                      products['selectedSize'] =sizeNames[selectedSize];
                                                      cartID = addToCart();
                                                      final snackBar = SnackBar(
                                                        content: Text('Added to Cart!'),
                                                      );
                                                      ScaffoldMessenger.of(context)
                                                          .showSnackBar(snackBar);
                                                    }
                                                    else {
                                                      ExtendedNavigator.of(context)
                                                          .push(
                                                          Routes.welcomeScreen);
                                                    }
                                                  },
                                                  child: Container(
                                                    width: width * 0.1,
                                                    height: height / 20,
                                                    margin: EdgeInsets.fromLTRB(
                                                        height / 32,
                                                        height / 64,
                                                        height / 32,
                                                        height / 32),
                                                    padding: EdgeInsets.all(
                                                        height / 100),
                                                    child: Center(
                                                      child: Text(
                                                        'Add to Cart',
                                                        style: TextStyle(
                                                          fontFamily: 'Lobster',
                                                        ),
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          211, 224, 234, 1),
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(15),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Similar Products',
                                      style: TextStyle(
                                        fontFamily: 'Lobster',
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: similarProds,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          isImageZoomed
                              ? FlatButton(
                            onPressed: () {
                              setState(() {
                                isImageZoomed = false;
                              });
                            },
                            child: Center(
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
                                height: height * 0.95,
                                width: width * 0.95,
                                child: Image.network(
                                  image,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          )
                              : Container(),
                        ],
                      );
                    else {
                      return Stack(
                        children: [
                          SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.all(height / 50),
                              child: Column(
                                children: [
                                  FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        isImageZoomed = true;
                                      });
                                    },
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: height * 17 / 20,
                                      ),
                                      child: Image.network(image),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: height / 15,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: images,
                                    ),
                                  ),
                                  SizedBox(height: 50),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      productName,
                                      style: TextStyle(
                                        fontFamily: 'Lobster',
                                        fontWeight: FontWeight.bold,
                                        fontSize: height / 32,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      productDetail,
                                      style: TextStyle(
                                        fontFamily: 'Lobster',
                                        fontWeight: FontWeight.w200,
                                        fontSize: height / 40,
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.grey,
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      '₹ $productPrice',
                                      style: TextStyle(
                                          fontFamily: 'Lobster',
                                          fontWeight: FontWeight.w300,
                                          fontSize: height / 40,
                                          color: Colors.pinkAccent),
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Properties',
                                      style: TextStyle(
                                        fontFamily: 'Lobster',
                                        fontWeight: FontWeight.bold,
                                        fontSize: height / 40,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: Column(
                                      children: displayProperty,
                                    ),
                                  ),
                                  SizedBox(height: 50),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Available ${getSizeCategory(
                                          products['subcategory'])}',
                                      style: TextStyle(
                                        fontFamily: 'Lobster',
                                        fontWeight: FontWeight.bold,
                                        fontSize: height / 40,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: sizeWidgets,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    height: height * 0.2,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(width: 1),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: height / 20,
                                          margin: EdgeInsets.fromLTRB(height / 32,
                                              height / 32, height / 32,
                                              height / 64),
                                          padding: EdgeInsets.all(height / 100),
                                          child: Center(
                                            child: Text(
                                              'Buy Now',
                                              style: TextStyle(
                                                fontFamily: 'Lobster',
                                              ),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                22, 135, 167, 1),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: () {
                                            if (_auth.currentUser != null) {
                                              addToCart();
                                              final snackBar = SnackBar(
                                                content: Text('Added to Cart!'),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            }
                                            else {
                                              ExtendedNavigator.of(context)
                                                  .push(
                                                  Routes.welcomeScreen);
                                            }
                                          },
                                          child: Container(
                                            height: height / 20,
                                            margin: EdgeInsets.fromLTRB(
                                                height / 32,
                                                height / 64, height / 32,
                                                height / 32),
                                            padding: EdgeInsets.all(height / 100),
                                            child: Center(
                                              child: Text(
                                                'Add to Cart',
                                                style: TextStyle(
                                                  fontFamily: 'Lobster',
                                                ),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  211, 224, 234, 1),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Similar Products',
                                        style: TextStyle(
                                          fontFamily: 'Lobster',
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: similarProds,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          isImageZoomed
                              ? FlatButton(
                            onPressed: () {
                              setState(() {
                                isImageZoomed = false;
                              });
                            },
                            child: Center(
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
                                height: height * 0.95,
                                width: width * 0.95,
                                child: Image.network(
                                  image,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          )
                              : Container(),
                        ],
                      );
                    }
                  },
                );
              }
          ),
        )
    );
  }

  String getValue(dynamic default_name, List<dynamic> names) {
    if (names.contains(default_name))
      return default_name;
    else {
      setState(() {
        size_default = names[0];
      });
      return names[0];
    }
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String user;

  dynamic addToCart() async{
    if (_auth != null) {
      user = _auth.currentUser.email;
    }
    var cartID;
    await _firestore.collection('cart').add({'product': products, 'user': user})
        .then((value) => cartID = value.id);
    return cartID;
  }

  DropdownButton<dynamic> buildDropdownButton(
      dynamic default_name, List<dynamic> names) {
    return DropdownButton<dynamic>(
      value: getValue(default_name, names),
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(fontFamily: 'Lobster', color: Colors.indigoAccent),
      underline: Container(
        height: 2,
        color: Colors.blueGrey[900],
      ),
      onChanged: (dynamic newValue) {
        setState(() {
          size_default = newValue;
        });
      },
      items: names.map<DropdownMenuItem<String>>((dynamic value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              fontFamily: 'Lobster',
            ),
          ),
        );
      }).toList(),
    );
  }
}
