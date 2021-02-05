import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:lilly_app/mockData.dart';

class SendReceive extends StatefulWidget {
  static const String id = 'send_receive';

  @override
  _SendReceiveState createState() => _SendReceiveState();
}

class _SendReceiveState extends State<SendReceive> {
  final db = FirebaseFirestore.instance;

  void addData(data, collection) {
    db.collection(collection).add(data);
  }

  void allData() {
    for (var i = 0; i < categories.length; i++) {
      addData(categories[i], 'categories');
    }

    for (var i = 0; i < subcategories.length; i++) {
      addData(subcategories[i], 'subcategories');
    }

    for (var i = 0; i < properties.length; i++) {
      addData(properties[i], 'properties');
    }

    for (var i = 0; i < propertyvalues.length; i++) {
      addData(propertyvalues[i], 'propertyvalues');
    }

    for (var i = 0; i < products.length; i++) {
      addData(products[i], 'products');
    }
  }

  @override
  Widget build(BuildContext context) {
    void f() {
      setState(() {});
    }

    return Scaffold(
      appBar: buildAppBar(context, f),
      body: Container(
        child: Center(
          child: FloatingActionButton(
            elevation: 20,
            child: Icon(Icons.add),
            onPressed: allData,
          ),
        ),
      ),
    );
  }
}
