import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:lilly_app/app/route.gr.dart';
import 'package:lilly_app/mockData.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final _firestore = FirebaseFirestore.instance;

class AddProductsDetails extends StatefulWidget {
  @override
  _AddProductsDetailsState createState() => _AddProductsDetailsState();
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

class _AddProductsDetailsState extends State<AddProductsDetails> {
  var category_default = 'Gents';
  var subcategory_default = 'Formals';

  var productName = '';
  var price = '';
  var description = '';
  var point = '';

  var property_default = 'Brand';
  var value_default = 'Diverse';
  var addedPropertiesOn = [];
  var addedPropertyList = [];
  var addedPointsOn = [];
  var addedPoints = [];

  List ImageFiles = [];
  List<Widget> images = [];
  List<bool> imagesSelected = [];
  List<PlatformFile> allFiles = [];

  var sizeCountValues = List.filled(8, '0');
  List<bool> sizeAvailable = List.filled(8,false);
  var ageCountValues = List.filled(7, '0');
  List<bool> ageAvailable = List.filled(7,false);
  var numberCountValues = List.filled(16, '0');
  List<bool> numberAvailable = List.filled(16,false);

  void getImages() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'bmp', 'jpeg'],
    );

    void deselectImage(var index) {
      setState(() {
        imagesSelected[index] = false;
      });
    }

    if (result != null) {
      List<PlatformFile> files = result.files;
      setState(() {
        for (int i = 0; i < files.length; i++) {
          allFiles.add(files[i]);
          var imageIndex = images.length;
          ImageFiles.add(files[i].name);
          images.add(
            Stack(
              children: <Widget>[
                Padding(
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
    }
  }

  @override
  void initState() {
    super.initState();
    setLastVisited();
  }

  void setLastVisited() async {
    var session = FlutterSession();
    await session.set("last_visited", Routes.addProductsDetails);
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

    var sub_category = [];
    for (var i = 0; i < subcategories.length; i++) {
      if (subcategories[i]['category'] == category_default) {
        sub_category.add(subcategories[i]['name']);
      }
    }

    var property = [];
    for (var i = 0; i < properties.length; i++) {
      property.add(properties[i]['name']);
    }

    var value = [];
    for (var i = 0; i < propertyvalues.length; i++) {
      if (propertyvalues[i]['property'] == property_default) {
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
        if (subcategories[i]['name'] == subcategory_default)
          return subcategories[i]['size_category'];
      }
    }

    return Scaffold(
        appBar: buildAppBar(context, f),
        body:
         // Builder(
         //  builder: (BuildContext context) {
         //    return
          Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildDropdownButton(
                            category_default, category, 'category'),
                        SizedBox(width: 30),
                        buildDropdownButton(
                            subcategory_default, sub_category, 'subcategory'),
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
                            buildDropdownButton(
                                property_default, property, 'property'),
                            SizedBox(width: 30),
                            buildDropdownButton(value_default, value, 'value'),
                            SizedBox(width: 10),
                            Container(
                              width: 40,
                              child: FlatButton(
                                onPressed: () =>
                                {
                                  addProperty(property_default, value_default),
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
                    ('size' == getSizeCategory())
                        ? Column(
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
                    )
                        : Container(),
                    ('age' == getSizeCategory())
                        ? Column(
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
                    )
                        : Container(),
                    ('number' == getSizeCategory())
                        ? Column(
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
                    )
                        : Container(),
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
                                  onPressed: () =>
                                  {
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
                    ElevatedButton(
                      onPressed: () {

                        var finalProperties = [];
                        for (var i = 0; i < addedPropertyList.length; i++) {
                          if (addedPropertiesOn[i]) {
                            finalProperties.add(addedPropertyList[i]);
                          }
                        }
                        var final_Points = [];
                        for (var i = 0; i < addedPoints.length; i++) {
                          if (addedPointsOn[i]) {
                            final_Points.add(addedPoints[i]);
                          }
                        }
                        var final_images = [];
                        for (var i = 0; i < ImageFiles.length; i++) {
                          if (imagesSelected[i]) {
                            final_images.add(ImageFiles[i]);
                            uploadPhotos(allFiles[i]);
                          }
                        }

                        var productDetails = {
                          'category': category_default,
                          'subcategory': subcategory_default,
                          'name': productName,
                          'price': price,
                          'description': description,
                          'properties': finalProperties,
                          'points': final_Points,
                          'sizeCounts': sizeCountValues,
                          'ageCounts': ageCountValues,
                          'numberCounts': numberCountValues,
                          'sizeAvailable': sizeAvailable,
                          'ageAvailable': ageAvailable,
                          'numberAvailable': numberAvailable,
                          'images': final_images,
                        };


                        if(productName!='' && price!='' && final_images.length!= 0){
                          // final snackBar = SnackBar(
                          //   content: Text('Product Added!'),
                          // );
                          _firestore.collection('productDetails').add(productDetails).then((value) => {

                           //ScaffoldMessenger.of(context).showSnackBar(snackBar),
                           updateSession(productDetails,value.id),
                          });
                          showAlertDialog(context);
                        }
                        else{
                          // final snackBar = SnackBar(
                          //   content: Text('Make sure to add Product name, Price and Images.'),
                          // );
                          //ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }

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
                            'Add',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          // }
        // ),
      );
  }


  void updateSession(dynamic product, dynamic id) async{
    product['id'] = id;
    var session = FlutterSession();
    var productsDetail = await session.get("prod_details");
    productsDetail = productsDetail['productDetails'];
    productsDetail.add(product);
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

  void addProperty(dynamic propertyDefault, dynamic valueDefault) {
    setState(() {
      addedPropertiesOn.add(true);
      addedPropertyList.add({
        'name': propertyDefault,
        'value': valueDefault,
      });
    });
  }

  void addPoints(dynamic Point) {
    setState(() {
      addedPointsOn.add(true);
      addedPoints.add(Point);
    });
  }

  String getValue(
      dynamic defaultName, List<dynamic> names, dynamic fieldName) {
    if (names.contains(defaultName)) return defaultName;
    setState(() {
      if (fieldName == 'subcategory')
        subcategory_default = names[0];
      else if (fieldName == 'value') value_default = names[0];
    });
    return names[0];
  }

  DropdownButton<dynamic> buildDropdownButton(dynamic default_name, List<dynamic> names, dynamic fieldname) {
    return DropdownButton<dynamic>(
      value: getValue(default_name, names, fieldname),
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.indigoAccent),
      underline: Container(
        height: 2,
        color: Colors.blueGrey[900],
      ),
      onChanged: (dynamic newValue) {
        print(newValue);
        setState(() {
          if (fieldname == 'category')
            category_default = newValue;
          else if (fieldname == 'subcategory')
            subcategory_default = newValue;
          else if (fieldname == 'property')
            property_default = newValue;
          else if (fieldname == 'value') value_default = newValue;
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
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        ExtendedNavigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Product Added."),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
