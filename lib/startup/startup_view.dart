import 'package:flutter/material.dart';
import 'package:lilly_app/startup/startup_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:lilly_app/app/route.gr.dart';

class StartupView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartupViewModel>.reactive(
      viewModelBuilder: () => StartupViewModel(),
      onModelReady: (model) => model.start,
      builder: (context, model, child) => Scaffold(
        body: Center(child: Text(model.title),),
        floatingActionButton: FloatingActionButton(
          onPressed:() => Navigator.pushNamed(context, Routes.storageView),
        ),
      ),
    );
  }
}
