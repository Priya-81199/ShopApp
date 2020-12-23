import 'package:firebase_storage/firebase_storage.dart';

class StorageService{

  FirebaseStorage storage = FirebaseStorage.instance;

  static void storeFile(){
    print("Inside the Storage Service");
  }
}