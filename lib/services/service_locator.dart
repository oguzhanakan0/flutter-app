import 'package:Optik/scoped_models/home_view_model.dart';
import 'package:get_it/get_it.dart';
import 'firebase_service.dart';

GetIt locator = GetIt();

void setupLocator(){
  locator.registerLazySingleton(()=> FirebaseService());

  locator.registerFactory<HomeViewModel>(()=> HomeViewModel());
}

