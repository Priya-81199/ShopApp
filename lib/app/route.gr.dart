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
import '../Screens/admin_chat_screen.dart';
import '../Screens/admin_orders.dart';
import '../Screens/admin_portal.dart';
import '../Screens/admin_prod_details.dart';
import '../Screens/admin_product_list.dart';
import '../Screens/cart.dart';
import '../Screens/chat_screen.dart';
import '../Screens/delivery_screen.dart';
import '../Screens/homePage.dart';
import '../Screens/login.dart';
import '../Screens/orders.dart';
import '../Screens/register.dart';
import '../Screens/solve_queries.dart';
import '../Screens/update_products.dart';
import '../Screens/welcome.dart';

class Routes {
  static const String loginScreen = '/login-screen';
  static const String addProductsDetails = '/add-products-details';
  static const String productList = '/product-list';
  static const String productDetails = '/product-details';
  static const String welcomeScreen = '/welcome-screen';
  static const String registrationScreen = '/registration-screen';
  static const String homePage = '/';
  static const String deliveryScreen = '/delivery-screen';
  static const String solveQueries = '/solve-queries';
  static const String cart = '/Cart';
  static const String updateProducts = '/update-products';
  static const String adminProductList = '/admin-product-list';
  static const String orders = '/Orders';
  static const String adminOrders = '/admin-orders';
  static const String adminProdDetails = '/admin-prod-details';
  static const String adminPortal = '/admin-portal';
  static const String chatScreen = '/chat-screen';
  static const String adminChatScreen = '/admin-chat-screen';
  static const all = <String>{
    loginScreen,
    addProductsDetails,
    productList,
    productDetails,
    welcomeScreen,
    registrationScreen,
    homePage,
    deliveryScreen,
    solveQueries,
    cart,
    updateProducts,
    adminProductList,
    orders,
    adminOrders,
    adminProdDetails,
    adminPortal,
    chatScreen,
    adminChatScreen,
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
    RouteDef(Routes.solveQueries, page: SolveQueries),
    RouteDef(Routes.cart, page: Cart),
    RouteDef(Routes.updateProducts, page: UpdateProducts),
    RouteDef(Routes.adminProductList, page: AdminProductList),
    RouteDef(Routes.orders, page: Orders),
    RouteDef(Routes.adminOrders, page: AdminOrders),
    RouteDef(Routes.adminProdDetails, page: AdminProdDetails),
    RouteDef(Routes.adminPortal, page: AdminPortal),
    RouteDef(Routes.chatScreen, page: ChatScreen),
    RouteDef(Routes.adminChatScreen, page: AdminChatScreen),
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
      return MaterialPageRoute<dynamic>(
        builder: (context) => ProductList(),
        settings: data,
      );
    },
    ProductDetails: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => ProductDetails(),
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
    UpdateProducts: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => UpdateProducts(),
        settings: data,
      );
    },
    AdminProductList: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => AdminProductList(),
        settings: data,
      );
    },
    Orders: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => Orders(),
        settings: data,
      );
    },
    AdminOrders: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => AdminOrders(),
        settings: data,
      );
    },
    AdminProdDetails: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => AdminProdDetails(),
        settings: data,
      );
    },
    AdminPortal: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => AdminPortal(),
        settings: data,
      );
    },
    ChatScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => ChatScreen(),
        settings: data,
      );
    },
    AdminChatScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => AdminChatScreen(),
        settings: data,
      );
    },
  };
}
