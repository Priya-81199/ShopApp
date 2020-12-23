// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../firebase_storage/storage_view.dart';
import '../startup/startup_view.dart';

class Routes {
  static const String startupView = '/';
  static const String storageView = '/storage-view';
  static const all = <String>{
    startupView,
    storageView,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startupView, page: StartupView),
    RouteDef(Routes.storageView, page: StorageView),
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
  };
}
