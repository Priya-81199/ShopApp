import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:lilly_app/app/route.gr.dart';
import 'package:lilly_app/mockData.dart'; //
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math';
import 'package:lilly_app/main.dart';
import 'ProductDetails.dart';

FirebaseStorage storage = FirebaseStorage.instance;

class AdminProductList extends StatefulWidget {
  static const String id = 'AdminProductList';

  @override
  _AdminProductListState createState() => _AdminProductListState();
}

class _AdminProductListState extends State<AdminProductList> {
  bool selectedData = false;
  var filterSet = [];
  var filterSetCount = [];
  var filterMapedIndex = {};
  var pageIndex = 1;

  _AdminProductListState() {
    for (var i = 0; i < properties.length; i++) {
      filterSet.add([]);
      filterSetCount.add(0);
      filterMapedIndex[properties[i]['name']] = i;
      for (var j = 0; j < properties[i]['value'].length; j++) {
        filterSet[i].add(false);
      }
    }
  }

  var productsDetails = [];
  var urls = [];
  bool image_set = false;
  var subcategory;
  @override
  void initState() {
    super.initState();
    setLastVisited();
    getData().then((value) => value.forEach((result) {
          var len = value.length;

          //storage.ref('product_images/' + result['images'][0]).getDownloadURL().then((value) {
          var url = getImageURL(result['images'][0]);

          productsDetails.add(result);
          urls.add(url);

          if (len == urls.length) {
            setState(() {
              image_set = true;
            });
          }
          // });
        }));
  }

  void setLastVisited() async {
    var session = FlutterSession();
    await session.set("last_visited", Routes.adminProductList);

  }

  RangeValues _currentRangeValues = const RangeValues(0, 10000);

  Future<List<dynamic>> getData() async {
    var session = FlutterSession();
    var productsDetail = await session.get("prod_details");
    return productsDetail['productDetails'];
  }

  @override
  Widget build(BuildContext context) {
    void f() {
      setState(() {});
    }

    var filters = <Widget>[];

    for (var i = 0; i < properties.length; i++) {
      var property = properties[i]['name'];

      var filteroptions = <Widget>[];
      for (var j = 0; j < properties[i]['value'].length; j++) {
        filteroptions.add(
          CheckboxListTile(
            title: Text(
              properties[i]['value'][j],
              style: TextStyle(fontFamily: 'Handlee'),
            ),
            value: filterSet[i][j],
            onChanged: (bool value) {
              setState(() {
                pageIndex = 1;
                filterSet[i][j] = value;
                if (value)
                  filterSetCount[i]++;
                else
                  filterSetCount[i]--;
              });
            },
          ),
        );
      }
      filters.add(
        ExpansionTile(
          title: Text(
            property,
            style: TextStyle(fontFamily: 'Lobster', fontSize: 16),
          ),
          children: filteroptions,
        ),
      );
    }
    filters.add(Text(
      'Price Range',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'Lobster',
      ),
    ));
    filters.add(RangeSlider(
      values: _currentRangeValues,
      min: 0,
      max: 10000,
      divisions: 20,
      labels: RangeLabels(
        _currentRangeValues.start.round().toString(),
        _currentRangeValues.end.round().toString(),
      ),
      onChanged: (RangeValues values) {
        setState(() {
          pageIndex = 1;
          _currentRangeValues = values;
        });
      },
    ));
    matched(dynamic valueToBeSatisfied, var filterIndex) {
      var flag = false;

      for (var i = 0; i < valueToBeSatisfied.length; i++) {
        for (var j = 0; j < properties[filterIndex]['value'].length; j++) {
          if (valueToBeSatisfied[i] == properties[filterIndex]['value'][j]) {
            flag = filterSet[filterIndex][j];
            break;
          }
        }
        if (flag) break;
      }
      return flag;
    }

    getProductCard(dynamic product, String url) {
      //print(url);
      return LayoutBuilder(
        builder: (context, constraints) {
          var width = constraints.maxWidth;
          var NamefontSize = width / 232 * 18;
          var PricefontSize = width / 232 * 16;
          var DescriptionfontSize = width / 232 * 12;
          return GestureDetector(
            onTap: () {
              // Navigator.push(
              //     context, new MaterialPageRoute(builder: (BuildContext context) => new ProductDetails(product))
              //   );
              ExtendedNavigator.of(context).push(Routes.updateProducts,
                  arguments: UpdateProductsArguments(product: product));
            },
            child: Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: Column(
                children: [
                  Container(
                      height: 0.65 * constraints.maxHeight,
                      child: Image.network(url)
                      //getURL(product['images'][0]).toString()),//TODO:Firebase storage se fetch karna
                      ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      product['name'],
                      style: TextStyle(
                        fontFamily: 'Lobster',
                        fontSize: NamefontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      product['description'],
                      style: TextStyle(
                        fontFamily: 'Handlee',
                        fontSize: DescriptionfontSize,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '₹' + product['price'],
                      style: TextStyle(
                        fontFamily: 'Lobster',
                        fontSize: PricefontSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.pinkAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    //var subcategory = 'subcategory 1';
    var displayProducts = <Widget>[];
    //var x=1;
    //print(productsDetails[0]['price']);
    for (var i = 0; i < productsDetails.length; i++) {
      var price = productsDetails[i]['price'];
      price = int.parse(price);
      if (price < _currentRangeValues.start || price > _currentRangeValues.end)
        continue;
      // if(productsDetails[i]['subcategory'] != subcategory)
      //   continue;
      var flag = true;
      var product = productsDetails[i];
      for (var j = 0; j < product['properties'].length; j++) {
        var property = product['properties'][j];
        var filterIndex = filterMapedIndex[property['name']];
        if (filterSetCount[filterIndex] > 0) {
          var valuesToBeSatisfied = [];
          if (properties[filterIndex]['select'] == 'single') {
            valuesToBeSatisfied.add(property['value']);
          } else {
            valuesToBeSatisfied = property['value'];
          }
          if (!matched(valuesToBeSatisfied, filterIndex)) {
            flag = false;
            break;
          }
        }
      }
      //
      //print(flag);
      if (flag && image_set) {
        displayProducts.add(getProductCard(product, urls[i]));
      }
    }

    var ProductsPerPage = 20;
    var pageButtons = <Widget>[];
    pageButtons.add(SizedBox(width: 10));
    for (var i = 1;
        i <= ((displayProducts.length) / ProductsPerPage).ceil();
        i++) {
      Color buttonColour = Color.fromRGBO(211, 224, 234, 1);
      if (i == pageIndex) buttonColour = Color.fromRGBO(22, 135, 167, 1);
      pageButtons.add(
        GestureDetector(
          onTap: () {
            setState(() {
              pageIndex = i;
            });
          },
          child: Container(
            height: 40,
            width: 40,
            color: buttonColour,
            child: Center(
                child: Text(
              '${i}',
              style: TextStyle(fontFamily: 'Handlee'),
            )),
          ),
        ),
      );
      pageButtons.add(SizedBox(width: 10));
    }

    return MaterialApp(
      home: Scaffold(
        drawer: Drawer(
          child: Container(
            padding: EdgeInsets.all(32.0),
            child: SingleChildScrollView(
              child: Column(
                children: filters,
              ),
            ),
          ),
        ),
        appBar: buildAppBar(context, f),
        body: LayoutBuilder(
          builder: (context, constraints) {
            var width = constraints.maxWidth;
            var columnCount = (width / 300).round();
            return CustomScrollView(
              slivers: [
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columnCount,
                    childAspectRatio: 0.65,
                  ),
                  delegate: SliverChildListDelegate(
                    displayProducts.sublist(
                        min((pageIndex - 1) * ProductsPerPage,
                            displayProducts.length),
                        min(pageIndex * ProductsPerPage,
                            displayProducts.length)),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: pageButtons,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
