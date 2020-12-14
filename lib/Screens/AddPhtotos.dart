import 'package:flutter/material.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:lilly_app/mockData.dart';
import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';



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
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'bmp'],
    );

    if(result != null) {

      PlatformFile file = result.files.first;
      setState(() {
        avail = true;
        images.add(Image.memory(file.bytes));
        print(images);
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
