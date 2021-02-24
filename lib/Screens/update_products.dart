import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:lilly_app/app/route.gr.dart';
import 'package:lilly_app/mockData.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class UpdateProducts extends StatefulWidget {
  final dynamic product;
  UpdateProducts(this.product);
  @override
  _UpdateProductsState createState() => _UpdateProductsState();
}

class Data {
  final List<dynamic> productDetails;
  Data({
    this.productDetails,
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["productDetails"] = productDetails;
    return data;
  }
}
class _UpdateProductsState extends State<UpdateProducts> {
  var categoryDefault = 'Gents';
  var subcategoryDefault = 'Formals';

  var productName = '';
  var price = '';
  var description = '';
  var point = '';

  var propertyDefault = 'Brand';
  var valueDefault = 'Diverse';
  var addedPropertiesOn = [];
  var addedPropertyList = [];
  var addedPointsOn = [];
  var addedPoints = [];

  List<PlatformFile> allFiles = [];
  var previousListLen = 0;

  List imageFiles = [];
  List<Widget> images = [];
  List<bool> imagesSelected = [];

  List<dynamic> sizeCountValues = List.filled(8, '0');
  List<dynamic> sizeAvailable = List.filled(8,false);
  List<dynamic> ageCountValues = List.filled(7, '0');
  List<dynamic> ageAvailable = List.filled(7,false);
  List<dynamic> numberCountValues = List.filled(16, '0');
  List<dynamic> numberAvailable = List.filled(16,false);

  void getImages() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'bmp', 'jpeg'],
    );

    if (result != null) {
      List<PlatformFile> files = result.files;
      setState(() {
        for (int i = 0; i < files.length; i++) {
          var imageIndex = images.length;
          imageFiles.add(files[i].name);
          allFiles.add(files[i]);
          images.add(
            Stack(
              children: <Widget>[
                FlatButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 200,
                      child: Image.memory(files[i].bytes),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.indigo, spreadRadius: 2)
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: FlatButton(
                    onPressed: () {
                      deselectImage(imageIndex);
                    },
                    child: Text(
                      'X',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
          imagesSelected.add(true);
        }
      });
    } else {
      // User canceled the picker
    }
  }

  void deselectImage(var index) {
    setState(() {
      imagesSelected[index] = false;
    });
  }

  var productID;

  @override
  void initState() {
    super.initState();
    var product = widget.product;
    print(product);
    productID = product['id'];
    categoryDefault = product['category'];
    subcategoryDefault = product['subcategory'];
    productName = product['name'];
    price = product['price'];
    description = product['description'];
    addedPropertyList = product['properties'];
    for (var i = 0; i < product['properties'].length; i++)
      addedPropertiesOn.add(true);
    addedPoints = product['points'];
    for (var i = 0; i < product['points'].length; i++) addedPointsOn.add(true);
    sizeCountValues = product['sizeCounts'];
    sizeAvailable = product['sizeAvailable'];
    ageCountValues = product['ageCounts'];
    ageAvailable = product['ageAvailable'];
    numberCountValues = product['numberCounts'];
    numberAvailable = product['numberAvailable'];
    previousListLen = product['images'].length;
    for (int i = 0; i < product['images'].length; i++) {
      var imageIndex = images.length;
      imageFiles.add(product['images'][i]);
      images.add(
        Stack(
          children: <Widget>[
            FlatButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 200,
                  child: Image.network(getImageURL(product['images'][i])),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.indigo, spreadRadius: 2)
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: FlatButton(
                onPressed: () {
                  deselectImage(imageIndex);
                },
                child: Text(
                  'X',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    backgroundColor: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      imagesSelected.add(true);
    }
    print(product);
  }

  @override
  Widget build(BuildContext context) {
    void f() {
      setState(() {});
    }

    var category = [];
    for (var i = 0; i < categories.length; i++) {
      category.add(categories[i]['name']);
    }

    var subCategory = [];
    for (var i = 0; i < subcategories.length; i++) {
      if (subcategories[i]['category'] == categoryDefault) {
        subCategory.add(subcategories[i]['name']);
      }
    }

    var property = [];
    for (var i = 0; i < properties.length; i++) {
      property.add(properties[i]['name']);
    }

    var value = [];
    for (var i = 0; i < propertyvalues.length; i++) {
      if (propertyvalues[i]['property'] == propertyDefault) {
        value.add(propertyvalues[i]['name']);
      }
    }

    List<Widget> propertiesPresent = [];
    for (var i = 0; i < addedPropertyList.length; i++) {
      if (addedPropertiesOn[i]) {
        propertiesPresent.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 75,
                child: Text(addedPropertyList[i]['name']),
              ),
              SizedBox(width: 30),
              Container(
                width: 75,
                child: Text(addedPropertyList[i]['value']),
              ),
              SizedBox(width: 10),
              Container(
                width: 40,
                child: FlatButton(
                  onPressed: () => {
                    removeProperty(i),
                  },
                  child: Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }

    List<Widget> pointsPresent = [];
    for (var i = 0; i < addedPoints.length; i++) {
      if (addedPointsOn[i]) {
        pointsPresent.add(
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(addedPoints[i]),
                ),
                SizedBox(width: 10),
                Container(
                  width: 40,
                  child: FlatButton(
                    onPressed: () => {
                      removePoint(i),
                    },
                    child: Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    List<Widget> displayImages = [];
    for (var i = 0; i < images.length; i++) {
      if (imagesSelected[i]) {
        displayImages.add(images[i]);
      }
    }
    displayImages.add(
      FloatingActionButton(
        onPressed: getImages,
        child: Icon(Icons.photo),
      ),
    );

    var sizeNames = ['4XS', '3XS', '2XS', 'XS', 'S', 'M', 'L', 'XL'];
    List<Widget> sizeCounts = [];
    sizeCounts.add(SizedBox(width: 30));
    for (var i = 0; i < sizeNames.length; i++) {
      sizeCounts.add(Column(
        children: [
          Container(
            child: Row(
              children: [
                Text(
                    sizeNames[i]
                ),
                Checkbox(
                  value: sizeAvailable[i],
                  onChanged: (isAvailable){
                    setState(() {
                      sizeAvailable[i] = isAvailable;
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            width: 30,
            child: TextFormField(
              initialValue: '${sizeCountValues[i]}',
              onChanged: (text) {
                setState(() {
                  sizeCountValues[i] = text;
                });
              },
            ),
          ),
        ],
      ));
      sizeCounts.add(SizedBox(width: 30));
    }

    var ageNames = [];
    for(var i=0;i<13;i+=2)
      ageNames.add(i.toString()+'-'+(i+1).toString());
    List<Widget> ageCounts = [];
    ageCounts.add(SizedBox(width: 30));
    for (var i = 0; i < ageNames.length; i++) {
      ageCounts.add(Column(
        children: [
          Container(
            child: Row(
              children: [
                Text(
                    ageNames[i]
                ),
                Checkbox(
                  value: ageAvailable[i],
                  onChanged: (isAvailable){
                    setState(() {
                      ageAvailable[i] = isAvailable;
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            width: 30,
            child: TextFormField(
              initialValue: '${ageCountValues[i]}',
              onChanged: (text) {
                setState(() {
                  ageCountValues[i] = text;
                });
              },
            ),
          ),
        ],
      ));
      ageCounts.add(SizedBox(width: 30));
    }

    var numberNames = [];
    for(var i=12;i<=42;i+=2)
      numberNames.add(i.toString());
    List<Widget> numberCounts = [];
    numberCounts.add(SizedBox(width: 30));
    for (var i = 0; i < numberNames.length; i++) {
      numberCounts.add(Column(
        children: [
          Container(
            child: Row(
              children: [
                Text(
                    numberNames[i]
                ),
                Checkbox(
                  value: numberAvailable[i],
                  onChanged: (isAvailable){
                    setState(() {
                      numberAvailable[i] = isAvailable;
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            width: 30,
            child: TextFormField(
              initialValue: '${numberCountValues[i]}',
              onChanged: (text) {
                setState(() {
                  numberCountValues[i] = text;
                });
              },
            ),
          ),
        ],
      ));
      numberCounts.add(SizedBox(width: 30));
    }

    String getSizeCategory() {
      for (var i = 0; i < subcategories.length; i++) {
        if (subcategories[i]['name'] == subcategoryDefault)
          return subcategories[i]['size_category'];
      }
      return '';
    }

    return MaterialApp(
      home: Scaffold(
        appBar: buildAppBar(context, f),
        body: Builder(
          builder: (BuildContext context) {
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildDropdownButton(categoryDefault, category, 'category'),
                        SizedBox(width: 30),
                        buildDropdownButton(subcategoryDefault, subCategory, 'subcategory'),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 240,
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Product Name',
                            ),
                            initialValue: productName,
                            onChanged: (text) {
                              setState(() {
                                productName = text;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 30),
                        Container(
                          width: 120,
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Price',
                            ),
                            initialValue: price,
                            onChanged: (text) {
                              price = text;
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 390,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        initialValue: description,
                        onChanged: (text) {
                          setState(() {
                            description = text;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    Column(
                      children: [
                        Text(
                          'Properties',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildDropdownButton(propertyDefault, property, 'property'),
                            SizedBox(width: 30),
                            buildDropdownButton(valueDefault, value, 'value'),
                            SizedBox(width: 10),
                            Container(
                              width: 40,
                              child: FlatButton(
                                onPressed: () => {
                                  addproperty(propertyDefault, valueDefault),
                                },
                                child: Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: propertiesPresent,
                    ),
                    ('size' == getSizeCategory()) ?
                      Column(
                        children: [
                          SizedBox(height: 30),
                          Text(
                            'Sizes Count',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: sizeCounts,
                            ),
                          ),
                        ],
                      ) :
                      Container(),
                      ('age' == getSizeCategory()) ?
                        Column(
                          children: [
                            SizedBox(height: 30),
                            Text(
                              'Age',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: ageCounts,
                              ),
                            ),
                          ],
                        ) :
                        Container(),
                      ('number' == getSizeCategory()) ?
                        Column(
                          children: [
                            SizedBox(height: 30),
                            Text(
                              'Number',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: numberCounts,
                              ),
                            ),
                          ],
                        ) :
                      Container(),
                    SizedBox(height: 30),
                    Column(
                      children: [
                        Text(
                          'Additional Points',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 390,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Point',
                                  ),
                                  initialValue: point,
                                  onChanged: (text) {
                                    point = text;
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 40,
                                child: FlatButton(
                                  onPressed: () => {
                                    addPoints(point),
                                  },
                                  child: Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: pointsPresent,
                    ),
                    SizedBox(height: 30),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: displayImages,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                          onPressed: () {
                            var finalProperties = [];
                            for (var i = 0; i < addedPropertyList.length; i++) {
                              if (addedPropertiesOn[i]) {
                                finalProperties.add(addedPropertyList[i]);
                              }
                            }
                            var finalPoints = [];
                            for (var i = 0; i < addedPoints.length; i++) {
                              if (addedPointsOn[i]) {
                                finalPoints.add(addedPoints[i]);
                              }
                            }
                            var finalImages = [];
                            for (var i = 0; i < imageFiles.length; i++) {
                              if (imagesSelected[i]) {
                                finalImages.add(imageFiles[i]);
                                if(i >= previousListLen)
                                  uploadPhotos(allFiles[i-previousListLen]);
                              }
                            }
                            var productDetails = {
                              'category': categoryDefault,
                              'subcategory': subcategoryDefault,
                              'name': productName,
                              'price': price,
                              'description': description,
                              'properties': finalProperties,
                              'points': finalPoints,
                              'sizeCounts': sizeCountValues,
                              'ageCounts': ageCountValues,
                              'numberCounts': numberCountValues,
                              'sizeAvailable': sizeAvailable,
                              'ageAvailable': ageAvailable,
                              'numberAvailable': numberAvailable,
                              'images': finalImages,
                            };
                            final snackBar = SnackBar(
                              content: Text('Product Updated!'),
                            );
                            _firestore
                            .collection('productDetails')
                            .doc(productID)
                            .update(productDetails)
                            .then((value) async => {
                              ScaffoldMessenger.of(context).showSnackBar(snackBar),
                              updateSession(productDetails,productID),
                              await Future.delayed(Duration(seconds: 1)),
                            })
                            .then((value) => ExtendedNavigator.of(context).popAndPush(Routes.adminProductList),);
                          },
                          child: Container(
                            height: 50,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Update',
                                style: TextStyle(
                                  fontFamily: 'Lobster',
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        FlatButton(
                          onPressed: () {
                            final snackBar = SnackBar(
                              content: Text('Product Removed!'),
                            );
                            _firestore
                            .collection('productDetails')
                            .doc(productID)
                            .delete()
                            .then((value)  async => {
                              removeProdSession(productID),
                              ScaffoldMessenger.of(context).showSnackBar(snackBar),
                              await Future.delayed(Duration(seconds: 1)),
                            })
                            .then((value)=> {
                              ExtendedNavigator.of(context).popAndPush(Routes.adminProductList)
                            });
                          },
                          child: Container(
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Remove Product',
                                style: TextStyle(
                                  fontFamily: 'Lobster',
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        FlatButton(
                          onPressed: () {
                            ExtendedNavigator.of(context).pop();
                          },
                          child: Container(
                            height: 50,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.pink.shade900,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontFamily: 'Lobster',
                                    fontSize: 20,
                                  ),
                                ),
                                Icon(
                                  Icons.highlight_remove_rounded,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void updateSession(dynamic product,dynamic id) async{
    var session = FlutterSession();
    var productsDetail = await session.get("prod_details");
    productsDetail = productsDetail['productDetails'];
    productsDetail[productsDetail.indexWhere((element) => element['id'] == id)] = product;
    await session.set("prod_details",Data(productDetails:productsDetail ));
  }

  void removeProdSession(dynamic id) async{
    var session = FlutterSession();
    var productsDetail = await session.get("prod_details");
    productsDetail = productsDetail['productDetails'];
    productsDetail.removeWhere((element) => element['id'] == id);
    await session.set("prod_details",Data(productDetails:productsDetail ));
  }

  void removeProperty(dynamic propertyIndex) {
    setState(() {
      addedPropertiesOn[propertyIndex] = false;
    });
  }

  void removePoint(dynamic propertyIndex) {
    setState(() {
      addedPointsOn[propertyIndex] = false;
    });
  }

  void addproperty(dynamic propertyDefault, dynamic valueDefault) {
    setState(() {
      addedPropertiesOn.add(true);
      addedPropertyList.add({
        'name': propertyDefault,
        'value': valueDefault,
      });
    });
  }

  void addPoints(dynamic point) {
    setState(() {
      addedPointsOn.add(true);
      addedPoints.add(point);
    });
  }

  String getValue(dynamic defaultName, List<dynamic> names, dynamic fieldName) {
    if (names.contains(defaultName)) return defaultName;
    setState(() {
      if (fieldName == 'subcategory')
        subcategoryDefault = names[0];
      else if (fieldName == 'value') valueDefault = names[0];
    });
    return names[0];
  }

  DropdownButton<dynamic> buildDropdownButton(
      dynamic defaultName, List<dynamic> names, dynamic fieldName) {
    return DropdownButton<dynamic>(
      value: getValue(defaultName, names, fieldName),
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.indigoAccent),
      underline: Container(
        height: 2,
        color: Colors.blueGrey[900],
      ),
      onChanged: (dynamic newValue) {
        setState(() {
          if (fieldName == 'category')
            categoryDefault = newValue;
          else if (fieldName == 'subcategory')
            subcategoryDefault = newValue;
          else if (fieldName == 'property')
            propertyDefault = newValue;
          else if (fieldName == 'value') valueDefault = newValue;
        });
      },
      items: names.map<DropdownMenuItem<String>>((dynamic value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
