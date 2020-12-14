import 'package:flutter/material.dart';
//import 'package:lilly_app/mockData.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class EditSubcat extends StatefulWidget {

  static const String id = "EditSubcat";
  @override

  _EditSubcatState createState() => _EditSubcatState();
}
final _firestore = FirebaseFirestore.instance;


class _EditSubcatState extends State<EditSubcat> {
  List<Map<dynamic, dynamic>> categories = [];
  List<Map<dynamic, dynamic>> subcategories = [];
  void getData(String collection) {
    _firestore.collection(collection).get().then((value) {
      value.docs.forEach((result) {
        if (collection == 'categories')
          categories.add(result.data());
        else if (collection == 'subcategories')
          subcategories.add(result.data());
      });
    });
  }
  _EditSubcatState(){
    getData('categories');
    getData('subcategories');
  }
  @override

  final subcategory = <Widget>[];
  Widget build(BuildContext context) {

    subcategory.add(Row(
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
      subcategory.add(
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
                        children: subcategory,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
