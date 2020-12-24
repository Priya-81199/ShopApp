import 'package:auto_route/auto_route_annotations.dart';
import 'package:lilly_app/Screens/login.dart';
import 'package:lilly_app/firebase_storage/storage_view.dart';
import 'package:lilly_app/startup/startup_view.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    // initial route is named "/"
    MaterialRoute(page: StartupView, ),
    MaterialRoute(page: StorageView,),
    MaterialRoute(page: LoginScreen,initial: true),
  ],
)
class $Router {

}