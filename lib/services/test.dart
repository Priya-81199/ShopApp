import 'package:flutter/material.dart';
import 'package:lilly_app/services/storage_service.dart';

class test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<String> url = StorageService.getImageURL();
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child:Image.network(url.toString()),
        ),
      ),
    );
  }
}
