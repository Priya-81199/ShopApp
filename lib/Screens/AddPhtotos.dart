//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:lilly_app/mockData.dart';
import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;


class AddPhotos extends StatefulWidget {
  static const String id = 'AddPhotos';

  @override
  _AddPhotosState createState() => _AddPhotosState();
}

class _AddPhotosState extends State<AddPhotos> {

  List<Widget> images = [];
  bool avail = false;

  void getImages() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'bmp'],
    );

    if(result != null) {
      List<PlatformFile> files = result.files;
      setState(() {
        avail = true;
        for(int i = 0 ; i < files.length ; i++) {
          images.add(Container(width: 30, child: Image.memory(files[i].bytes)));
        }
      });

    } else {
      // User canceled the picker
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: avail? Container(
        child: Row(
          children: images,
        )
      )
      :
      Container(),
      floatingActionButton: FloatingActionButton(
        elevation: 20,
        child: Icon(Icons.photo),
        onPressed: getImages,
    ),
    );
  }
}
