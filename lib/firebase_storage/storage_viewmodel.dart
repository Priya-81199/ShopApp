import 'package:flutter/cupertino.dart';
import 'package:lilly_app/services/storage_service.dart';

class StorageViewModel extends ChangeNotifier{

  void start(){
    print("Inside the storage view model");
    StorageService.storeFile();
    notifyListeners();
  }

}