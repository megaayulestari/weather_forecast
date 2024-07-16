import 'package:dartz/dartz.dart';
import 'package:weather_forecast/core/error/failure.dart';
import 'package:weather_forecast/feature/weather/domain/entities/weather_entity.dart';

abstract class WeatherRepository {
  //memisahkan flow error berdasarkan tipe class failure, ketika sukses akan dapat WeatherEntity
  Future<Either<Failure, WeatherEntity>> getCurrentWeather(String cityName);
  Future<Either<Failure, List<WeatherEntity>>> getHourlyForecast(
    String cityName,
  );
}