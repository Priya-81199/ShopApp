import 'package:flutter/cupertino.dart';

class StartupViewModel extends ChangeNotifier{
  String title = 'hey there';

  void start(){
    title = 'YOOOOO';
    notifyListeners();
  }

}