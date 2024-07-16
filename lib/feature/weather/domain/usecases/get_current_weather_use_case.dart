
import 'package:dartz/dartz.dart';
import 'package:weather_forecast/core/error/failure.dart';
import 'package:weather_forecast/feature/weather/domain/entities/weather_entity.dart';
import 'package:weather_forecast/feature/weather/domain/repositories/weather_repository.dart';


class GetCurrentWeatherUseCase{
  final WeatherRepository _repository;

  GetCurrentWeatherUseCase(this._repository);

  Future<Either<Failure, WeatherEntity>> call(String cityName) {
    return _repository.getCurrentWeather(cityName);
  }
}