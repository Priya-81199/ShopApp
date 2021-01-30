import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lilly_app/Screens/welcome.dart';
import 'package:lilly_app/main.dart';
import '../mockData.dart';
import 'delivery_screen.dart';

FirebaseStorage storage = FirebaseStorage.instance;



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
  var size_default='L';

  var urls = [];
  bool image_set=false;
  var products;
  @override
  void initState() {
    super.initState();
    products = widget.product;
    print(products);
    for (var i = 0; i < products['images'].length; i++) {
      storage.ref('product_images/' + products['images'][i])
          .getDownloadURL()
          .then((value) {
        urls.add(value);
        if (products['images'].length == urls.length) {
          setState(() {
            image_set = true;
          });
        }
      });
    }
  }


  var selectedSize = -1;
  @override
  Widget build(BuildContext context) {
    //print(products);
    String getSizeCategory(String subcategory){
      for(var i=0 ; i<subcategories.length;i++){
        if(subcategories[i]['name'] == subcategory)
          return subcategories[i]['size_category'];
      }
    }
    var image;
    if(urls.length > selectedImageIndex)
      image = urls[selectedImageIndex];
    else
      image = 'https://www.bluechipexterminating.com/wp-content/uploads/2020/02/loading-gif-png-5.gif';
    List<Widget> images = [];
    List<Widget> displayProperty = [];
    var productName = products['name'];
    var productDetail = products['description'];
    var productPrice = products['price'];
    var productAddPoints = products['points'];
    //String addDetails = '';
    var sizes = (getSizeCategory(products['subcategory']) == 'size') ?
      products['sizeCounts']:
      (getSizeCategory(products['subcategory']) == 'age') ?
        products['ageCounts']:
        products['numberCounts'];
    List<bool> availableSizes = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false];
    List<Widget> sizeWidgets = [];

    List<String> sizeNames = (getSizeCategory(products['subcategory']) == 'size') ?
      ['4XS','3XS','2XS','XS','S','M','L','XL']:
      (getSizeCategory(products['subcategory']) == 'age') ?
        ['0-1','2-3','4-5','6-7','8-9','10-11','12-13']:
        ['12', '14', '16','18', '20', '22','24', '26', '28','30', '32', '34','36', '38', '40','42'];

    // for(int i = 0; i < productAddPoints.length;i++){
    //   addDetails = addDetails + productAddPoints[i];
    // }

    for(int i = 0; i < sizes.length;i++){
      if(int.parse(sizes[i]) > 0){
        availableSizes[i] = true;
      }
    }
    //print(availableSizes);
    images.add(
      SizedBox(width: 10),
    );

    for(var i=0; i<sizeNames.length; i++) {
      if(availableSizes[i]) {
        sizeWidgets.add(
            GestureDetector(
                onTap: () {
                  setState(() {
                    selectedSize = i;
                  });
                },
                child: Container(
                    width: 60,
                    height: 40,
                    padding: EdgeInsets.all(5),
                    child: Center(
                        child: Text(sizeNames[i])
                    ),
                    decoration: BoxDecoration(
                      color: (i==selectedSize)?Colors.orangeAccent:Colors.yellow,
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
    for(var i=0; i<products['images'].length; i++) {
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
          child: urls.length > i ?Container(
            color: Colors.black,
            padding: EdgeInsets.all(paddingSize),
            child:  Image.network(urls[i]),
          )
                :CircularProgressIndicator()
        )
      );
      images.add(
        SizedBox(width: 10),
      );
    }

    for(var i=0; i<products['properties'].length; i++) {
      displayProperty.add(
        Container(
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              Text(
                products['properties'][i]['name'] + ': ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

              Text(
                products['properties'][i]['value'],
                style: TextStyle(
                  fontSize: 20,
                ),
              )
            ]
          ),
        ),
      );
    }
    for(var i=0; i<products['points'].length; i++){
      displayProperty.add(
        Container(
          padding: EdgeInsets.all(5),
          child: Row(
              children: [
                Text(
                  products['points'][i],
                  style: TextStyle(
                    fontSize: 20,
                  ),
                )
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
                              child: Image.network(image),
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
                              '₹ $productPrice',
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
                          SizedBox(
                              height: 20
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Available Sizes',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: height/40,
                              ),
                            ),
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
                          SizedBox(
                              height: 20
                          ),
                          Container(
                            height: height*0.20,
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
                                  height: height/20,
                                  margin: EdgeInsets.fromLTRB(height/32, height/32, height/32, height/64),
                                  padding: EdgeInsets.all(height/100),
                                  child: Center(
                                    child: FlatButton(
                                      onPressed: () {(isUserSet)?
                                        Navigator.push(
                                          context, new MaterialPageRoute(builder: (BuildContext context) => new DeliveryScreen())
                                      ):
                                      Navigator.push(
                                          context, new MaterialPageRoute(builder: (BuildContext context) => new WelcomeScreen())
                                      );
                                      },
                                      child: Text(
                                        'Buy Now',
                                      ),
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
                      child: Image.network(
                        image,
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
                              child: Image.network(image),
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
                                  '₹ $productPrice',
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
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Available Sizes',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: height/40,
                              ),
                            ),
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
                          SizedBox(
                              height: 20
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
                        child: Image.network(
                          image,
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

