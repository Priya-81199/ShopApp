import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart' as pp;

class StorageService{

  static void storeFile() async{
    FirebaseStorage storage = FirebaseStorage.instance;

    print("Inside the Storage Service");
    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // File downloadToFile = File('${appDocDir.path}/download-logo.png');

    ListResult result = await storage.ref().listAll();

    print(result);


    result.items.forEach((Reference ref) {
      print('Found file: $ref');
      print(ref.getDownloadURL());

    });

    result.prefixes.forEach((Reference ref) {
      print('Found directory: $ref');

    });

  }
}