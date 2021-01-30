import 'package:auto_route/auto_route_annotations.dart';
import 'package:lilly_app/Screens/ProductDetails.dart';
import 'package:lilly_app/Screens/ProductList.dart';
import 'package:lilly_app/Screens/addProducts1.dart';
import 'package:lilly_app/Screens/delivery_screen.dart';
import 'package:lilly_app/Screens/homePage.dart';
import 'package:lilly_app/Screens/login.dart';
import 'package:lilly_app/Screens/register.dart';
import 'package:lilly_app/Screens/welcome.dart';
import 'package:lilly_app/firebase_storage/storage_view.dart';
import 'package:lilly_app/payment_gateway/pay.dart';
import 'package:lilly_app/services/test.dart';
import 'package:lilly_app/startup/startup_view.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    // initial route is named "/"
    MaterialRoute(page: StartupView,),
    MaterialRoute(page: StorageView,),
    MaterialRoute(page: LoginScreen,),
    MaterialRoute(page: AddProductsDetails,),
    MaterialRoute(page: ProductList,),
    MaterialRoute(page: ProductDetails,),
    MaterialRoute(page: WelcomeScreen,),
    MaterialRoute(page: RegistrationScreen,),
    MaterialRoute(page: homePage,),
    MaterialRoute(page: DeliveryScreen,),
    MaterialRoute(page: RazorPayWeb,initial: true),
  ],
)
class $Router {

}