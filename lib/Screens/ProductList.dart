
import 'package:flutter/material.dart';
import 'package:lilly_app/mockData.dart'; //
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseStorage storage = FirebaseStorage.instance;
class ProductList extends StatefulWidget {
  static const String id = 'ProductList';
  @override
  _ProductListState createState() => _ProductListState();
}


class _ProductListState extends State<ProductList> {



  bool selectedData = false;
  var filterSet = [];
  var filterSetCount = [];
  var filterMapedIndex = {};

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
    super.initState();
    final db = FirebaseFirestore.instance;

      db.collection('productDetails').get().then((value) {
        value.docs.forEach((result) {
          productsDetails.add(result.data());
          urls.add(storage.ref('dress4_2.jpeg').getDownloadURL().then((value) {
            print(value);
          })
              .toString());
        });
      });

  }



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
      print(url);
      return LayoutBuilder(
        builder: (context, constraints){
          var width = constraints.maxWidth;
          var NamefontSize = width/232*20;
          var PricefontSize = width/232*18;
          var DescriptionfontSize = width/232*14;
          return Container(
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
                    'This is a smal description one line sentence',
                    style: TextStyle(
                      fontSize: DescriptionfontSize,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '₹ 2,300',
                    style: TextStyle(
                      fontSize: PricefontSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.pinkAccent,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    //var subcategory = 'subcategory 1';
    var displayProducts = <Widget>[];
    //var x=1;
    for(var i=0; i < productsDetails.length ; i++) //TODO : change products to productsDetails(Firebase)
    {
      // if(productsDetails[i]['subcategory'] != subcategory)
      //   continue;
      var flag=true;
      var product=productsDetails[i];
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
      if(flag) {
        if(urls.length==products.length) {
          displayProducts.add(getProductCard(product, urls[i]));
        }
        else
          {
            setState(() {
              image_set=false;
            });
          }
      }
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
            return GridView.count(
              crossAxisCount: columnCount,
              childAspectRatio: 0.65,
              children: displayProducts,
            );
          },
        ),
      ),
    );
  }
}