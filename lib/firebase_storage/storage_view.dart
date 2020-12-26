import 'package:flutter/material.dart';
import 'package:lilly_app/firebase_storage/storage_viewmodel.dart';
import 'package:stacked/stacked.dart';

class StorageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StorageViewModel>.reactive(
        viewModelBuilder: () => StorageViewModel(),
      onModelReady: (model) => model.start,
      builder: (context, model, child) => Scaffold(
        body: Center(child: Column(
          children: [
            Text("Inside the Storage View"),

            Image.network(model.url)
          ],
        ),),
        floatingActionButton: FloatingActionButton(
          onPressed: model.start,
        ),
        //body: Center(child: Image.asset(model.receiveFile),),
      ),
    );
  }
}
