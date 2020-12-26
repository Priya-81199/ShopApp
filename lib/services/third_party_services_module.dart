import 'package:injectable/injectable.dart';
import 'package:lilly_app/services/storage_service.dart';
import 'package:stacked_services/stacked_services.dart';

@module
abstract class ThirdPartyServicesModule {
  @lazySingleton
  StorageService get storageService;
  @lazySingleton
  NavigationService get navigationService;
}