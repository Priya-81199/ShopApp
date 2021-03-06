import 'package:auto_route/auto_route_annotations.dart';
import 'package:lilly_app/Screens/Components.dart';
import 'package:lilly_app/Screens/ProductDetails.dart';
import 'package:lilly_app/Screens/ProductList.dart';
import 'package:lilly_app/Screens/addProducts1.dart';
import 'package:lilly_app/Screens/admin_chat_screen.dart';
import 'package:lilly_app/Screens/admin_orders.dart';
import 'package:lilly_app/Screens/admin_portal.dart';
import 'package:lilly_app/Screens/admin_prod_details.dart';
import 'package:lilly_app/Screens/admin_product_list.dart';
import 'package:lilly_app/Screens/cart.dart';
import 'package:lilly_app/Screens/chat_screen.dart';
import 'package:lilly_app/Screens/delivery_screen.dart';
import 'package:lilly_app/Screens/homePage.dart';
import 'package:lilly_app/Screens/intro_screen.dart';
import 'package:lilly_app/Screens/login.dart';
import 'package:lilly_app/Screens/orders.dart';
import 'package:lilly_app/Screens/register.dart';
import 'package:lilly_app/Screens/solve_queries.dart';
import 'package:lilly_app/Screens/update_products.dart';
import 'package:lilly_app/Screens/welcome.dart';
import 'package:lilly_app/main.dart';


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
    MaterialRoute(page: SolveQueries),
    MaterialRoute(page: Cart,),
    MaterialRoute(page: UpdateProducts,),
    MaterialRoute(page: AdminProductList,),
    MaterialRoute(page: Orders,),
    MaterialRoute(page: AdminOrders,),
    MaterialRoute(page: AdminProdDetails,),
    MaterialRoute(page: AdminPortal,),
    MaterialRoute(page: ChatScreen,),
    MaterialRoute(page: AdminChatScreen,),
    MaterialRoute(page: IntroPage,initial: true),
  ],
)
class $Router {

}