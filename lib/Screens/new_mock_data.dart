import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Components.dart';

class MockData extends StatefulWidget {
  static const String id = 'mock_data';
  @override
  _MockDataState createState() => _MockDataState();
}
final _firestore = FirebaseFirestore.instance;

class _MockDataState extends State<MockData> {

  List<Map<dynamic, dynamic>> categories = [];


  void getData(String collection) {

      _firestore.collection(collection).get().then((value) {

        value.docs.forEach((result) {
          if(collection == 'categories')
            categories.add(result.data());

        });
      });

  }
  _MockDataState(){
    getData('categories');
  }
  void checkData() {
    print(categories);
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: buildAppBar(context),
      body: Container(
        child: Center(
          child: Column(
            children: [

              FloatingActionButton(
                elevation: 20,
                child: Icon(Icons.add),
                onPressed:() => {
                  checkData()
                },

              ),
            ],
          ),
        ),
      ),
    );
  }
}