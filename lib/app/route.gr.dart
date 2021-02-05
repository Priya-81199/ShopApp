// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../Screens/ProductDetails.dart';
import '../Screens/ProductList.dart';
import '../Screens/addProducts1.dart';
import '../Screens/admin_product_list.dart';
import '../Screens/admin_products.dart';
import '../Screens/cart.dart';
import '../Screens/delivery_screen.dart';
import '../Screens/homePage.dart';
import '../Screens/login.dart';
import '../Screens/register.dart';
import '../Screens/solve_queries.dart';
import '../Screens/update_products.dart';
import '../Screens/welcome.dart';
import '../payment_gateway/pay.dart';

class Routes {
  static const String loginScreen = '/login-screen';
  static const String addProductsDetails = '/add-products-details';
  static const String productList = '/product-list';
  static const String productDetails = '/product-details';
  static const String welcomeScreen = '/welcome-screen';
  static const String registrationScreen = '/registration-screen';
  static const String homePage = '/';
  static const String deliveryScreen = '/delivery-screen';
  static const String razorPayWeb = '/razor-pay-web';
  static const String solveQueries = '/solve-queries';
  static const String cart = '/Cart';
  static const String adminProducts = '/admin-products';
  static const String updateProducts = '/update-products';
  static const String adminProductList = '/admin-product-list';
  static const all = <String>{
    loginScreen,
    addProductsDetails,
    productList,
    productDetails,
    welcomeScreen,
    registrationScreen,
    homePage,
    deliveryScreen,
    razorPayWeb,
    solveQueries,
    cart,
    adminProducts,
    updateProducts,
    adminProductList,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.loginScreen, page: LoginScreen),
    RouteDef(Routes.addProductsDetails, page: AddProductsDetails),
    RouteDef(Routes.productList, page: ProductList),
    RouteDef(Routes.productDetails, page: ProductDetails),
    RouteDef(Routes.welcomeScreen, page: WelcomeScreen),
    RouteDef(Routes.registrationScreen, page: RegistrationScreen),
    RouteDef(Routes.homePage, page: homePage),
    RouteDef(Routes.deliveryScreen, page: DeliveryScreen),
    RouteDef(Routes.razorPayWeb, page: RazorPayWeb),
    RouteDef(Routes.solveQueries, page: SolveQueries),
    RouteDef(Routes.cart, page: Cart),
    RouteDef(Routes.adminProducts, page: AdminProducts),
    RouteDef(Routes.updateProducts, page: UpdateProducts),
    RouteDef(Routes.adminProductList, page: AdminProductList),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    LoginScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => LoginScreen(),
        settings: data,
      );
    },
    AddProductsDetails: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => AddProductsDetails(),
        settings: data,
      );
    },
    ProductList: (data) {
      final args = data.getArgs<ProductListArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ProductList(args.subcategory),
        settings: data,
      );
    },
    ProductDetails: (data) {
      final args = data.getArgs<ProductDetailsArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ProductDetails(args.product),
        settings: data,
      );
    },
    WelcomeScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => WelcomeScreen(),
        settings: data,
      );
    },
    RegistrationScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => RegistrationScreen(),
        settings: data,
      );
    },
    homePage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => homePage(),
        settings: data,
      );
    },
    DeliveryScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => DeliveryScreen(),
        settings: data,
      );
    },
    RazorPayWeb: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => RazorPayWeb(),
        settings: data,
      );
    },
    SolveQueries: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SolveQueries(),
        settings: data,
      );
    },
    Cart: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => Cart(),
        settings: data,
      );
    },
    AdminProducts: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => AdminProducts(),
        settings: data,
      );
    },
    UpdateProducts: (data) {
      final args = data.getArgs<UpdateProductsArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => UpdateProducts(args.product),
        settings: data,
      );
    },
    AdminProductList: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => AdminProductList(),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// ProductList arguments holder class
class ProductListArguments {
  final dynamic subcategory;
  ProductListArguments({@required this.subcategory});
}

/// ProductDetails arguments holder class
class ProductDetailsArguments {
  final dynamic product;
  ProductDetailsArguments({@required this.product});
}

/// UpdateProducts arguments holder class
class UpdateProductsArguments {
  final dynamic product;
  UpdateProductsArguments({@required this.product});
}
