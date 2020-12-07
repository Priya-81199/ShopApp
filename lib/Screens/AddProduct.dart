import 'package:flutter/material.dart';
import 'package:lilly_app/mockData.dart';

class AddProduct extends StatefulWidget {
  static const String id = "AddProduct";

  @override
  _AddProductState createState() => _AddProductState();

}


class _AddProductState extends State<AddProduct> {

  var category_default = 'category 1';
  var subcategory_default = 'Subcategory1';

  @override
  Widget build(BuildContext context) {
    void Dap(){
      print('Helloji');
    }
    final category = [];
    for(var i = 0 ; i < categories.length ; i++) {
      category.add(categories[i]['name']);
    }

    var flag = 1;
    final sub_category = [];
    for(var i = 0 ; i < subcategories.length ; i++) {
      if(subcategories[i]['category'] == category_default) {
        if(flag==1) {
          flag = 0;
          setState(() {
            subcategory_default = subcategories[i]['name'];
          });
        }
        sub_category.add(subcategories[i]['name']);
      }
    }
    print(category_default);
    print(category);


    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Center(child: Text('Lilly App')),
        ),
        body : Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildDropdownButton(category_default, category,'category'),
                  buildDropdownButton(subcategory_default, sub_category,'subcategory'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Product Name"),
                  Text("Description"),
                  Text("Price")
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: CircleAvatar(

                  ),
                ),
                Container(
                  child: CircleAvatar(

                  ),
                ),
                IconButton(
                  onPressed: Dap,
                  icon: Icon(Icons.add),
                )
               ],
              ),
              Column(

               children: [
                 Text('Properties',style: TextStyle(fontWeight: FontWeight.bold),),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     Text("Material"),
                     Text("Cotton"),
                     FlatButton(onPressed: Dap, child: Text('Add new value'),),
                   ],
                 ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     Text("Size"),
                     Text("L/XL"),
                     FlatButton(onPressed: Dap, child: Text('Add new value'),),
                   ],
                 ),
                 IconButton(
                   onPressed: Dap,
                   icon: Icon(Icons.add),
                 )
               ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownButton<dynamic> buildDropdownButton(dynamic default_name, List<dynamic> names, dynamic fieldname) {

      print(default_name);
      print(names);
      print(fieldname);
    return DropdownButton<dynamic>(
      value:default_name,
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

