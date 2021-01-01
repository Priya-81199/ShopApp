import 'package:flutter/material.dart';
import 'package:lilly_app/mockData.dart'; //
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math';
import 'package:lilly_app/app/route.gr.dart' as rg;

import 'ProductDetails.dart';

FirebaseStorage storage = FirebaseStorage.instance;

class ProductListArguments{
  final dynamic subcategory;
  ProductListArguments({this.subcategory});
   dynamic get Subcategory{
    return subcategory;
  }
}

class ProductList extends StatefulWidget {
  static const String id = 'ProductList';
  final dynamic subcategory;
  ProductList(this.subcategory);
  @override
  _ProductListState createState() => _ProductListState();
}




class _ProductListState extends State<ProductList> {



  bool selectedData = false;
  var filterSet = [];
  var filterSetCount = [];
  var filterMapedIndex = {};
  var pageIndex = 1;

  _ProductListState() {
    for (var i = 0; i < properties.length; i++) {
      filterSet.add([]);
      filterSetCount.add(0);
      filterMapedIndex[properties[i]['name']]=i;
      for (var j=0; j < properties[i]['value'].length; j++) {
        filterSet[i].add(false);
      }
    }
  }

  var productsDetails = [];
  var urls = [];
  bool image_set=false;
  @override
  void initState() {

    print(widget.subcategory);
    super.initState();
    final db = FirebaseFirestore.instance;

      db.collection('productDetails').get().then((value) {
        var len = value.docs.length;
        value.docs.forEach((result) {

          storage.ref('product_images/' + result.data()['images'][0]).getDownloadURL().then((value) {
            productsDetails.add(result.data());
            urls.add(value);
            if(len==urls.length){
              setState(() {
                image_set=true;
              });
            }
          });
        });
      });

  }
  RangeValues _currentRangeValues = const RangeValues(0, 10000);

  @override
  Widget build(BuildContext context) {
    var filters = <Widget>[];

    for (var i = 0; i < properties.length; i++) {
      var property = properties[i]['name'];

      var filteroptions = <Widget>[];
      for (var j=0; j < properties[i]['value'].length; j++) {
        filteroptions.add(
          CheckboxListTile(
            title: Text(properties[i]['value'][j]),
            value: filterSet[i][j],
            onChanged: (bool value) {
              setState(() {
                filterSet[i][j] = value;
                if(value)
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
          title: Text(property, style: TextStyle(fontSize: 16),),
          children: filteroptions,
        ),
      );
    }
    filters.add(
      Text('Price Range',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
    );
    filters.add(
        RangeSlider(
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
              _currentRangeValues = values;
            });
          },
        )
    );
    matched(dynamic valueToBeSatisfied, var filterIndex){
      var flag = false;

      for(var i=0; i<valueToBeSatisfied.length; i++)
      {
        for(var j=0; j<properties[filterIndex]['value'].length; j++) {
          if(valueToBeSatisfied[i]==properties[filterIndex]['value'][j])
          {
            flag = filterSet[filterIndex][j];
            break;
          }
        }
        if(flag)
          break;
      }
      return flag;
    }

    Future<String> getURL(String img_name) async{
      print("Inside the Storage Service");



      final ref = storage.ref().child('dress4_2.jpeg');

      return await ref.getDownloadURL();

    }



    getProductCard(dynamic product,String url) {
      //print(url);
      return LayoutBuilder(
        builder: (context, constraints){
          var width = constraints.maxWidth;
          var NamefontSize = width/232*20;
          var PricefontSize = width/232*18;
          var DescriptionfontSize = width/232*14;
          return GestureDetector(
            onTap: (){
              Navigator.push(
                  context, new MaterialPageRoute(builder: (BuildContext context) => new ProductDetails(product))
                );
              },
            child: Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: Column(
                children: [
                  Container(
                    height: 0.65*constraints.maxHeight,
                    child: Image.network(
                        url
                    )
                        //getURL(product['images'][0]).toString()),//TODO:Firebase storage se fetch karna
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      product['name'],
                      style: TextStyle(
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
                        fontSize: DescriptionfontSize,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '₹'+ product['price'],
                      style: TextStyle(
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
    //print(productsDetails.length);
    //print(productsDetails[0]['price']);
    for(var i=0; i < productsDetails.length ; i++) //TODO : change products to productsDetails(Firebase)
    {
      var price = productsDetails[i]['price'];
      price = int.parse(price);
      if( price < _currentRangeValues.start || price > _currentRangeValues.end)
        continue;
        // if(productsDetails[i]['subcategory'] != subcategory)
      //   continue;
      var flag=true;
      var product = productsDetails[i];
      for (var j=0; j < product['properties'].length; j++)
      {
        var property = product['properties'][j];
        var filterIndex = filterMapedIndex[property['name']];
        if(filterSetCount[filterIndex] > 0)
        {
          var valuesToBeSatisfied = [];
          if(properties[filterIndex]['select']=='single') {
            valuesToBeSatisfied.add(property['value']);
          }
          else {
            valuesToBeSatisfied = property['value'];
          }
          if(!matched(valuesToBeSatisfied, filterIndex))
          {
            flag=false;
            break;
          }
        }
      }
      //
      //print(flag);
      if(flag && image_set) {

          displayProducts.add(getProductCard(product, urls[i]));
      }
    }

    var ProductsPerPage=20;
    var pageButtons = <Widget>[];
    pageButtons.add(SizedBox(width: 10));
    for(var i=1;i<=((displayProducts.length)/ProductsPerPage).ceil();i++)
    {
      Color buttonColour = Colors.orangeAccent;
      if(i==pageIndex)
        buttonColour = Colors.deepOrangeAccent;
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
            child: Center(child: Text('${i}')),
          ),
        ),
      );
      pageButtons.add(SizedBox(width: 10));
    }

    return  Scaffold(
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
        appBar: AppBar(
          title: Text(
            'Lilly',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            var width = constraints.maxWidth;
            var columnCount = (width/212).round();
            return  CustomScrollView(
              slivers: [
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columnCount,
                    childAspectRatio: 0.65,
                  ),
                  delegate: SliverChildListDelegate(
                    displayProducts.sublist(
                        min((pageIndex-1)*ProductsPerPage,displayProducts.length),
                        min(pageIndex*ProductsPerPage, displayProducts.length)
                    ),
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
                      SizedBox(height: 20,)
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );

  }
}