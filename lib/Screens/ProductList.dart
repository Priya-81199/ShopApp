import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:lilly_app/app/route.gr.dart';
import 'package:lilly_app/mockData.dart';
import 'dart:math';

class ProductList extends StatefulWidget {
  static const String id = 'ProductList';
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  bool selectedData = false;
  var filterSet = [];
  var filterSetCount = [];
  var filterMappedIndex = {};
  var pageIndex = 1;

  _ProductListState() {
    for (var i = 0; i < properties.length; i++) {
      filterSet.add([]);
      filterSetCount.add(0);
      filterMappedIndex[properties[i]['name']] = i;
      for (var j = 0; j < properties[i]['value'].length; j++) {
        filterSet[i].add(false);
      }
    }
  }

  var productsDetails = [];
  bool imageSet = false;
  var subcategory;
  @override
  void initState() {
    super.initState();
    setLastVisited();
    getArguments();
    getData().then((value) async => {
      value.forEach((result) {

        var len = value.length;
        productsDetails.add(result);
        if (len == productsDetails.length) {
          setState(() {
            imageSet = true;
          });
        }
      }),
    });
  }

  void getArguments() async {
    var session = FlutterSession();
    subcategory = await session.get('argument_subcat');
  }

  void setLastVisited() async {
    var session = FlutterSession();
    await session.set("last_visited", Routes.productList);
    await session.set("arguments", subcategory);
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

      var filterOptions = <Widget>[];
      for (var j = 0; j < properties[i]['value'].length; j++) {
        filterOptions.add(
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
          children: filterOptions,
        ),
      );
    }
    filters.add(
      Text(
        'Price Range',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Lobster',
        ),
      ),
    );
    filters.add(
      Text(
        '₹0 - ₹10,000',
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'Handlee',
          color: Colors.pink,
        ),
      ),
    );
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

    getProductCard(dynamic product) {
      return LayoutBuilder(
        builder: (context, constraints) {
          var width = constraints.maxWidth;
          var height = constraints.maxHeight;
          return getCard(context, product, width, height);
        },
      );
    }

    var displayProducts = <Widget>[];
    for (var i = 0; i < productsDetails.length; i++) {
      var price = productsDetails[i]['price'];

      price = int.parse(price);
      if (price < _currentRangeValues.start || price > _currentRangeValues.end)
        continue;
      if (productsDetails[i]['subcategory'] != subcategory) continue;
      var flag = true;
      var product = productsDetails[i];
      for (var j = 0; j < product['properties'].length; j++) {
        var property = product['properties'][j];
        var filterIndex = filterMappedIndex[property['name']];
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
      if (flag && imageSet) {
        displayProducts.add(getProductCard(product));
      }
    }

    var productsPerPage = 20;
    var pageButtons = <Widget>[];
    pageButtons.add(SizedBox(width: 10));
    for (var i = 1;
    i <= ((displayProducts.length) / productsPerPage).ceil();
    i++) {
      Color buttonColour = Color.fromRGBO(211, 224, 234, 1);
      if (i == pageIndex) buttonColour = Color.fromRGBO(22, 135, 167, 1);
      pageButtons.add(
        FlatButton(
          onPressed: () {
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
                  '$i',
                  style: TextStyle(fontFamily: 'Handlee'),
                )),
          ),
        ),
      );
      pageButtons.add(SizedBox(width: 10));
    }

    return Scaffold(
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
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              var width = constraints.maxWidth;
              var height = constraints.maxHeight;
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
                        min(
                          (pageIndex - 1) * productsPerPage,
                          displayProducts.length,
                        ),
                        min(
                          pageIndex * productsPerPage,
                          displayProducts.length,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        subcategory.toString() == 'Formals' ||
                            subcategory.toString() == 'Casuals' ||
                            subcategory.toString() == 'Ethnic'
                            ? Container(
                          height: height,
                              child: Center(
                                child: Text(
                              'Coming Soon.',
                                style: TextStyle(
                                  fontSize: 50,
                                  fontFamily: 'AT',
                                  color: Colors.grey.shade600),
                            ),
                          ),
                        )
                            : Center(
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
        ],
      ),
    );
  }
}