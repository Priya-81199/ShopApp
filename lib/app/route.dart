import 'package:auto_route/auto_route_annotations.dart';
import 'package:lilly_app/Screens/ProductDetails.dart';
import 'package:lilly_app/Screens/ProductList.dart';
import 'package:lilly_app/Screens/addProducts1.dart';
import 'package:lilly_app/Screens/admin_product_list.dart';
import 'package:lilly_app/Screens/admin_products.dart';
import 'package:lilly_app/Screens/cart.dart';
import 'package:lilly_app/Screens/delivery_screen.dart';
import 'package:lilly_app/Screens/homePage.dart';
import 'package:lilly_app/Screens/login.dart';
import 'package:lilly_app/Screens/register.dart';
import 'package:lilly_app/Screens/solve_queries.dart';
import 'package:lilly_app/Screens/update_products.dart';
import 'package:lilly_app/Screens/welcome.dart';
import 'package:lilly_app/payment_gateway/pay.dart';


@MaterialAutoRouter(
  routes: <AutoRoute>[
    // initial route is named "/"
    MaterialRoute(page: LoginScreen,),
    MaterialRoute(page: AddProductsDetails,),
    MaterialRoute(page: ProductList,),
    MaterialRoute(page: ProductDetails,),
    MaterialRoute(page: WelcomeScreen,),
    MaterialRoute(page: RegistrationScreen,),
    MaterialRoute(page: homePage,),
    MaterialRoute(page: DeliveryScreen,),
    MaterialRoute(page: RazorPayWeb,),
    MaterialRoute(page: SolveQueries),
    MaterialRoute(page: Cart,),
    MaterialRoute(page: AdminProducts,),
    MaterialRoute(page: UpdateProducts,),
    MaterialRoute(page: AdminProductList,initial: true,)
  ],
)
class $Router {

}