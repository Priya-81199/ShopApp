import 'package:flutter/material.dart';
//import 'package:lilly_app/mockData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class AddProduct extends StatefulWidget {

  static const String id = 'AddProduct';
  @override
  _AddProductState createState() => _AddProductState();

}


final _firestore = FirebaseFirestore.instance;


class _AddProductState extends State<AddProduct> {


  List<Map<dynamic, dynamic>> categories = [];
  List<Map<dynamic, dynamic>> subcategories = [];
  List<Map<dynamic, dynamic>> products = [];
  List<Map<dynamic, dynamic>> properties = [];
  List<Map<dynamic, dynamic>> propertyvalues = [];

  void getData(String collection) {
    _firestore.collection(collection).get().then((value) {
      value.docs.forEach((result) {
        if (collection == 'categories')
          categories.add(result.data());
        else if (collection == 'subcategories')
          subcategories.add(result.data());
        else if (collection == 'products')
          products.add(result.data());
        else if (collection == 'properties')
          products.add(result.data());
        else if (collection == 'propertyvalues')
          products.add(result.data());
      });
    });
  }
    _AddProductState(){
      getData('categories');
      getData('subcategories');
      getData('products');
      getData('properties');
      getData('propertyvalues');
    }

  var category_default = 'category 1';
  var subcategory_default = 'Subcategory1';
  var property_default = 'Brand';
  var value_default = 'Diverse';

  List<Widget> addedProperties = [];
  var addedPropertiesOn = [];

  @override
  Widget build(BuildContext context) {
    //Firebase.initializeApp();
    var category = [];
    for(var i = 0 ; i < categories.length ; i++) {
      category.add(categories[i]['name']);
    }
    var sub_category = [];
    for(var i = 0 ; i < subcategories.length ; i++) {
      if(subcategories[i]['category'] == category_default) {
        sub_category.add(subcategories[i]['name']);
      }
    }

    var property = [];
    for(var i = 0; i < properties.length ; i++) {
      property.add(properties[i]['name']);
    }

    var value = [];
    for(var i = 0 ; i < propertyvalues.length ; i++) {
      if(propertyvalues[i]['property'] == property_default) {
        value.add(propertyvalues[i]['name']);
      }
    }

    List<Widget> propertiesPresent = [];
    for(var i = 0 ; i < addedProperties.length ; i++) {
      if(addedPropertiesOn[i]) {
        propertiesPresent.add(addedProperties[i]);
      }
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Center(child: Text('Lilly App')),
        ),
        body : Container(
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //buildDropdownButton(category_default, category,'category'),
                  SizedBox(width: 30),
                  //buildDropdownButton(subcategory_default, sub_category,'subcategory'),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Product Name',
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  Container(
                    width: 120,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: 270,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // children: [
              //   Container(
              //     child: CircleAvatar(
              //
              //     ),
              //   ),
              //   Container(
              //     child: CircleAvatar(
              //
              //     ),
              //   ),
              //   IconButton(
              //     onPressed: Dap,
              //     icon: Icon(Icons.add),
              //   )
              //  ],
              // ),
              Column(
               children: [
                 Text('Properties',style: TextStyle(fontWeight: FontWeight.bold),),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     //buildDropdownButton(property_default, property,'property'),
                     SizedBox(width: 30),
                     //buildDropdownButton(value_default, value,'value'),
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
            ],
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

  void addproperty(dynamic property_default, dynamic value_default){
    var PropertyIndex = addedProperties.length;
    setState(() {
      addedPropertiesOn.add(true);
      addedProperties.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 75,
                child: Text(property_default),
              ),
              SizedBox(width: 30),
              Container(
                width: 75,
                child: Text(value_default),
              ),
              SizedBox(width: 10),
              Container(
                width: 40,
                child: FlatButton(
                  onPressed: () => {
                    removeProperty(PropertyIndex),
                  },
                  child: Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          )
      );
    });
  }

  String getValue(dynamic default_name, List<dynamic> names, dynamic fieldname){
    if(names.contains(default_name))
      return default_name;
    setState(() {
      if(fieldname == 'subcategory')
        subcategory_default = names[0];
      else if(fieldname == 'value')
        value_default = names[0];
    });

    return names[0];

  }

  DropdownButton<dynamic> buildDropdownButton(dynamic default_name, List<dynamic> names, dynamic fieldname) {

    return DropdownButton<dynamic>(
      value:getValue(default_name, names,fieldname),
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
          if(fieldname == 'category')
            category_default = newValue;
          else if(fieldname == 'subcategory')
            subcategory_default = newValue;
          else if(fieldname == 'property')
            property_default = newValue;
          else if(fieldname == 'value')
            value_default = newValue;
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

