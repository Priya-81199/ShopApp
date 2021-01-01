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
import '../Screens/homePage.dart';
import '../Screens/login.dart';
import '../firebase_storage/storage_view.dart';
import '../startup/startup_view.dart';

class Routes {
  static const String startupView = '/startup-view';
  static const String storageView = '/storage-view';
  static const String loginScreen = '/login-screen';
  static const String addProductsDetails = '/add-products-details';
  static const String productList = '/';
  static const String productDetails = '/product-details';
  static const String homePage = '/home-page';
  static const all = <String>{
    startupView,
    storageView,
    loginScreen,
    addProductsDetails,
    productList,
    productDetails,
    homePage,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startupView, page: StartupView),
    RouteDef(Routes.storageView, page: StorageView),
    RouteDef(Routes.loginScreen, page: LoginScreen),
    RouteDef(Routes.addProductsDetails, page: AddProductsDetails),
    RouteDef(Routes.productList, page: ProductList),
    RouteDef(Routes.productDetails, page: ProductDetails),
    RouteDef(Routes.homePage, page: homePage),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    StartupView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => StartupView(),
        settings: data,
      );
    },
    StorageView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => StorageView(),
        settings: data,
      );
    },
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
    homePage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => homePage(),
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
