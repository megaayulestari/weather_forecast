import 'package:weather_forecast/commons/app_session.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_forecast/feature/pick_place/presentation/cubit/city_cubit.dart';

final locator = GetIt.instance;

Future<void> initlocator() async{
  // cubit / bloc
  locator.registerFactory(() => CityCubit(locator()));

  //external
  final pref = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => AppSession(pref));
}