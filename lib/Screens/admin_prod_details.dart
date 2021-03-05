import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import '../mockData.dart';
import 'Components.dart' as comp;
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

class AdminProdDetails extends StatefulWidget {
  static const String id = 'AdminProdDetails';
  @override
  _AdminProdDetailsState createState() => _AdminProdDetailsState();
}

class _AdminProdDetailsState extends State<AdminProdDetails> {
  var productIndex = 1;
  var selectedImageIndex = 0;
  var isImageZoomed = false;
  var size_default = 'L';

  var urls = [];
  bool image_set = false;
  var products;

  void getArguments() async {
    var session = FlutterSession();
    products = await session.get('argument_aprod');
    products = products['product'];
    setLastVisited();
    for (var i = 0; i < products['images'].length; i++) {
      urls.add(comp.getImageURL(products['images'][i]));
      if (products['images'].length == urls.length) {
        setState(() {
          image_set = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getArguments();
  }

  void setLastVisited() async {
    var session = FlutterSession();
    await session.set("last_visited", Routes.adminProdDetails);
    print(Routes.productDetails);
    await session.set("arguments", Data(product: products));
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
    var availableSizes = (getSizeCategory(products['subcategory']) == 'size')
        ? products['sizeAvailable']
        : (getSizeCategory(products['subcategory']) == 'age')
            ? products['ageAvailable']
            : products['numberAvailable'];

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

    //print(availableSizes);
    images.add(
      SizedBox(width: 10),
    );

    for (var i = 0; i < sizeNames.length; i++) {
      if (availableSizes[i]) {
        sizeWidgets.add(
          FlatButton(
            hoverColor: Colors.transparent,
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
          hoverColor: Colors.transparent,
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

    Column imageSection(height) {
      return Column(
        children: [
          FlatButton(
            hoverColor: Colors.transparent,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: images,
              ),
            ),
          ),
        ],
      );
    }

    Column detailSection(height, width, difference) {
      return Column(
        children: [
          Container(
            width: width,
            alignment: Alignment.topLeft,
            child: Text(
              productName,
              style: TextStyle(
                fontFamily: 'Lobster',
                fontWeight: FontWeight.bold,
                fontSize: height / (28 - difference),
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
                fontSize: height / (36 - difference),
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
                  fontSize: height / (36 - difference),
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
                fontSize: height / (34 - difference),
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
              'Selected ${getSizeCategory(products['subcategory'])}',
              style: TextStyle(
                fontFamily: 'Lobster',
                fontWeight: FontWeight.bold,
                fontSize: height / (34 - difference),
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
        ],
      );
    }

    FlatButton zoomImage(height, width, fit) {
      return FlatButton(
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
              fit: fit,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: comp.buildAppBar(context, f),
      body: Builder(builder: (BuildContext context) {
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
                              child: imageSection(height),
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
                                  detailSection(height, width * 2 / 5, 0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  isImageZoomed
                      ? zoomImage(height, width, BoxFit.fitHeight)
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
                          imageSection(height),
                          SizedBox(height: 50),
                          detailSection(height, width, 4),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  isImageZoomed
                      ? zoomImage(height, width, BoxFit.fitWidth)
                      : Container(),
                ],
              );
            }
          },
        );
      }),
    );
  }
}
