import 'package:weather_forecast/commons/app_session.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_forecast/feature/pick_place/presentation/cubit/city_cubit.dart';
import 'package:weather_forecast/feature/weather/data/data_source/weather_remote_data_source.dart';
import 'package:weather_forecast/feature/weather/data/repositories/weather_repository_impl.dart';
import 'package:weather_forecast/feature/weather/domain/repositories/weather_repository.dart';
import 'package:weather_forecast/feature/weather/domain/usecases/get_current_weather_use_case.dart';
import 'package:weather_forecast/feature/weather/domain/usecases/get_hourly_forecast_use_case.dart';
import 'package:weather_forecast/feature/weather/presentation/bloc/current_weather/current_weather_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:weather_forecast/feature/weather/presentation/bloc/hourly_forecast/hourly_forecast_bloc.dart';

final locator = GetIt.instance;

Future<void> initlocator() async{
  // cubit / bloc
  locator.registerFactory(() => CityCubit(locator()));
  locator.registerFactory(() => CurrentWeatherBloc(locator(), locator()));
   locator.registerFactory(() => HourlyForecastBloc(locator(), locator()));

  //usecase
  locator.registerLazySingleton(() => GetCurrentWeatherUseCase(locator()));
  locator.registerLazySingleton(() => GetHourlyForecastUseCase(locator()));

  //datasource
  locator.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(locator()),
  );

  //repository
  locator.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(locator()),
  );

  //common 
  locator.registerLazySingleton(
    () => AppSession(locator()),
  );

  //external
  final pref = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => pref);
  locator.registerLazySingleton(() => http.Client());
}