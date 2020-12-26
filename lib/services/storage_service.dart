import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart' as pp;

class StorageService{

  static Future<String> getImageURL() async{
    FirebaseStorage storage = FirebaseStorage.instance;

    print("Inside the Storage Service");
    final ref = storage.ref().child('dress4_2.jpeg');

    var url = await ref.getDownloadURL();
    print(url);

    return url;
  }

  static void storeFile() async{

    //ListResult result = await storage.ref().listAll();

    //print(result);


    // result.items.forEach((Reference ref) {
    //   print('Found file: $ref');
    // });
    //
    // result.prefixes.forEach((Reference ref) {
    //   print('Found directory: $ref');
    // });

  }
}