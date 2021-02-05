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

class _AddProductsDetailsState extends State<AddProductsDetails> {
  var category_default = 'Gents';
  var subcategory_default = 'subcategory 1';

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

  var sizeCountValues = ['0', '0', '0', '0', '0', '0', '0', '0'];
  var ageCountValues = ['0', '0', '0', '0', '0', '0', '0'];
  var numberCountValues = [
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0'
  ];

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
          var imageIndex = images.length;
          ImageFiles.add(files[i].name);
          images.add(
            Stack(
              children: <Widget>[
                GestureDetector(
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
                  child: GestureDetector(
                    onTap: () {
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
  @override
  void initState() {
    // TODO: implement initState
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
      sizeCounts.add(Container(
        width: 30,
        child: TextFormField(
          initialValue: '${sizeCountValues[i]}',
          decoration: InputDecoration(
            labelText: sizeNames[i],
          ),
          onChanged: (text) {
            setState(() {
              sizeCountValues[i] = text;
            });
          },
        ),
      ));
      sizeCounts.add(SizedBox(width: 30));
    }

    var ageNames = ['0-1', '2-3', '4-5', '6-7', '8-9', '10-11', '12-13'];
    List<Widget> ageCounts = [];
    ageCounts.add(SizedBox(width: 30));
    for (var i = 0; i < ageNames.length; i++) {
      ageCounts.add(Container(
        width: 30,
        child: TextFormField(
          initialValue: '${ageCountValues[i]}',
          decoration: InputDecoration(
            labelText: ageNames[i],
          ),
          onChanged: (text) {
            setState(() {
              ageCountValues[i] = text;
            });
          },
        ),
      ));
      ageCounts.add(SizedBox(width: 30));
    }

    var numberNames = [
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
    List<Widget> numberCounts = [];
    numberCounts.add(SizedBox(width: 30));
    for (var i = 0; i < numberNames.length; i++) {
      numberCounts.add(Container(
        width: 30,
        child: TextFormField(
          initialValue: '${numberCountValues[i]}',
          decoration: InputDecoration(
            labelText: numberNames[i],
          ),
          onChanged: (text) {
            setState(() {
              numberCountValues[i] = text;
            });
          },
        ),
      ));
      numberCounts.add(SizedBox(width: 30));
    }

    String getSizeCategory() {
      for (var i = 0; i < subcategories.length; i++) {
        if (subcategories[i]['name'] == subcategory_default)
          return subcategories[i]['size_category'];
      }
    }

    return MaterialApp(
      home: Scaffold(
        appBar: buildAppBar(context, f),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildDropdownButton(category_default, category, 'category'),
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
                            onPressed: () => {
                              addproperty(property_default, value_default),
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
                  )),
                ),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
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
                      'images': final_images,
                    };
                    print(productDetails);
                    _firestore.collection('productDetails').add(productDetails);
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
      ),
    );
  }

  void removeProperty(dynamic PropertyIndex) {
    setState(() {
      addedPropertiesOn[PropertyIndex] = false;
    });
  }

  void removePoint(dynamic PropertyIndex) {
    setState(() {
      addedPointsOn[PropertyIndex] = false;
    });
  }

  void addproperty(dynamic property_default, dynamic value_default) {
    setState(() {
      addedPropertiesOn.add(true);
      addedPropertyList.add({
        'name': property_default,
        'value': value_default,
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
      dynamic default_name, List<dynamic> names, dynamic fieldname) {
    if (names.contains(default_name)) return default_name;
    setState(() {
      if (fieldname == 'subcategory')
        subcategory_default = names[0];
      else if (fieldname == 'value') value_default = names[0];
    });
    return names[0];
  }

  DropdownButton<dynamic> buildDropdownButton(
      dynamic default_name, List<dynamic> names, dynamic fieldname) {
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
}
