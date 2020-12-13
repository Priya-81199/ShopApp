import 'package:flutter/material.dart';
import 'package:lilly_app/mockData.dart';
import 'package:lilly_app/Screens/Components.dart';

class EditCart extends StatefulWidget {

  static const String id = "EditCart";
  @override

  _EditCartState createState() => _EditCartState();
}

class _EditCartState extends State<EditCart> {
  @override

  final cartItems = <Widget>[];
  Widget build(BuildContext context) {

    cartItems.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(width:100,child: Text('Categories',style: TextStyle(fontWeight: FontWeight.w700),)),
        SizedBox(width: 50),
        Container(width:100,child: Text('Sub Category',style: TextStyle(fontWeight: FontWeight.w700),)),
        SizedBox(width: 50),
        // Container(width:100,child: Text('Sub Category Image',style: TextStyle(fontWeight: FontWeight.w700),)),
        // SizedBox(width: 50),
        Container(width:100,child: Text('Action',style: TextStyle(fontWeight: FontWeight.w700),)),
      ],
    ),);

    for(var i = 0; i < subcategories.length; i++) {
      cartItems.add(
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: [
              Container(width:100,child: Text(subcategories[i]['category'])),
              SizedBox(width: 50),
              Container(width:100,child: Text(subcategories[i]['name'])),
              SizedBox(width: 50),
              // Container(width:100,child:Image.asset('images/'+subcategories[i]['image'])),
              // SizedBox(width: 50),
              Container(width:100,child:Row(children :[ IconButton(icon: Icon(Icons.edit,)),IconButton(icon: Icon(Icons.delete,))]))
            ],
          )
      );
    }
    return Scaffold(
      appBar: buildAppBar(context),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: cartItems,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
