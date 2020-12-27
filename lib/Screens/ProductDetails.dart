import 'package:flutter/material.dart';
import 'package:lilly_app/mockData.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseStorage storage = FirebaseStorage.instance;

class ProductDetailsArguments{
  final Map<String, dynamic> product;
  ProductDetailsArguments({this.product});
  Map<String,dynamic> get Product{
    return product;
  }
}


class ProductDetails extends StatefulWidget {
  static const String id = 'ProductDetails';

  @override
  _ProductDetailsState createState() => _ProductDetailsState();


}



class _ProductDetailsState extends State<ProductDetails> {

  var productIndex = 1;
  var selectedImageIndex = 0;
  var isImageZoomed = false;
  var size_default='L';




  @override
  Widget build(BuildContext context) {
    //print(Product);
    var image = products[productIndex]['images'][selectedImageIndex]['image'];
    List<Widget> images = [];
    List<Widget> displayProperty = [];
    var productName = products[productIndex]['name'];
    var productDetail = products[productIndex]['detail'];

    print(products[productIndex]['images'].length);

    images.add(
      SizedBox(width: 10),
    );
    for(var i=0; i<products[productIndex]['images'].length; i++) {
      double paddingSize = 0;
      if(i==selectedImageIndex)
        paddingSize=1;

      images.add(
        GestureDetector(
          onTap: (){
            setState(() {
              selectedImageIndex = i;
            });
          },
          child: Container(
            color: Colors.black,
            padding: EdgeInsets.all(paddingSize),
            child: Image.asset('images/'+products[productIndex]['images'][i]['image']),
          ),
        )
      );
      images.add(
        SizedBox(width: 10),
      );
    }

    for(var i=0; i<products[productIndex]['properties'].length; i++) {
      displayProperty.add(
        Container(
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              Text(
                products[productIndex]['properties'][i]['name'] + ': ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              (products[productIndex]['properties'][i]['name'] != 'Size') ?
              Text(
                products[productIndex]['properties'][i]['values'],
                style: TextStyle(
                  fontSize: 20,
                ),
              ):
              buildDropdownButton(size_default, products[productIndex]['properties'][i]['values']),
            ]
          ),
        ),
      );
    }

    return MaterialApp(
      home: Scaffold(
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
            var height = constraints.maxHeight;
            if(height<width)
              return Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: width*2/5,
                      height: height,
                      padding: EdgeInsets.all(height/50),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isImageZoomed = true;
                              });
                            },
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: height*17/20,
                              ),
                              child: Image.asset('images/'+image),
                            ),
                          ),
                          SizedBox(height: 20),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: height/15,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: images,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: width*2/5,
                      height: height,
                      padding: EdgeInsets.fromLTRB(height/50, height/25, height/50, 0),
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              productName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: height/32,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              productDetail,
                              style: TextStyle(
                                fontWeight: FontWeight.w200,
                                fontSize: height/40,
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
                              '₹ 530.00',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: height/40,
                                color: Colors.pinkAccent
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Properties',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: height/40,
                              ),
                            ),
                          ),
                          SizedBox(
                              height: 5
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Column(
                              children: displayProperty,
                            ),
                          ),
                          SizedBox(
                              height: 50
                          ),
                          Container(
                            height: height*0.18,
                            width: width/5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 1
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: width*0.1,
                                  height: height/25,
                                  margin: EdgeInsets.fromLTRB(height/32, height/32, height/32, height/64),
                                  padding: EdgeInsets.all(height/100),
                                  child: Center(
                                    child: Text(
                                      'Buy Now',
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orangeAccent,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: width*0.1,
                                  height: height/25,
                                  margin: EdgeInsets.fromLTRB(height/32, height/64, height/32, height/32),
                                  padding: EdgeInsets.all(height/100),
                                  child: Center(
                                    child: Text(
                                      'Add to Cart',
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
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
                isImageZoomed ?
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isImageZoomed = false;
                    });
                  },
                  child: Center(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      height: height*0.95,
                      width: width*0.95,
                      child: Image.asset(
                        'images/'+image,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ) :
                Container(),
              ],
            );
            else {
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(height/50),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isImageZoomed = true;
                              });
                            },
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: height*17/20,
                              ),
                              child: Image.asset('images/'+image),
                            ),
                          ),
                          SizedBox(height: 20),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: height/15,
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
                                  fontWeight: FontWeight.bold,
                                  fontSize: height/32,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                productDetail,
                                style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: height/40,
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
                                '₹ 530.00',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: height/40,
                                    color: Colors.pinkAccent
                                ),
                              ),
                            ),
                            SizedBox(
                                height: 40
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Properties',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: height/40,
                                ),
                              ),
                            ),
                            SizedBox(
                                height: 5
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: Column(
                                children: displayProperty,
                              ),
                            ),
                            SizedBox(
                                height: 50
                            ),
                            Container(
                              height: height*0.2,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    width: 1
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: height/20,
                                    margin: EdgeInsets.fromLTRB(height/32, height/32, height/32, height/64),
                                    padding: EdgeInsets.all(height/100),
                                    child: Center(
                                      child: Text(
                                        'Buy Now',
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orangeAccent,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: height/20,
                                    margin: EdgeInsets.fromLTRB(height/32, height/64, height/32, height/32),
                                    padding: EdgeInsets.all(height/100),
                                    child: Center(
                                      child: Text(
                                        'Add to Cart',
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ),
                  ),
                  isImageZoomed ?
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isImageZoomed = false;
                      });
                    },
                    child: Center(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        height: height*0.95,
                        width: width*0.95,
                        child: Image.asset(
                          'images/'+image,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ) :
                  Container(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  String getValue(dynamic default_name, List<dynamic> names){
    if(names.contains(default_name))
      return default_name;
    else{
      setState(() {
        size_default = names[0];
      });
      return names[0];
    }
  }

  DropdownButton<dynamic> buildDropdownButton(dynamic default_name, List<dynamic> names) {
    return DropdownButton<dynamic>(
      value: getValue(default_name, names),
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(
          color: Colors.indigoAccent
      ),
      underline: Container(
        height: 2,
        color: Colors.blueGrey[900],
      ),
      onChanged: (dynamic newValue) {
        setState(() {
            size_default = newValue;
        });
      },
      items: names
          .map<DropdownMenuItem<String>>((dynamic value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      })
          .toList(),
    );
  }
}

