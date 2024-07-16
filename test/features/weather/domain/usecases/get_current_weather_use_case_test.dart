import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_forecast/core/error/failure.dart';
import 'package:weather_forecast/feature/weather/domain/usecases/get_current_weather_use_case.dart';

import '../../../../helpers/weather_mock.mocks.dart';
import '../../../../helpers/dummy_data/weather_data.dart';

//Skema testing untuk use case
void main() {
  late MockWeatherRepository mockWeatherRepository;
  late GetCurrentWeatherUseCase useCase;
  //kirim repository


  //inisialisasi nilai, mock dimasukkan ke usecase
  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    useCase = GetCurrentWeatherUseCase(mockWeatherRepository);
  });


  //proses testing ketika success
  test(
    'should return [WeatherEntity] when repository success',
    () async {
      // arrange
      when(
        mockWeatherRepository.getCurrentWeather(any)
      ).thenAnswer(
        (_) async=> Right(tWeatherEntity)
      );

      // act
      final result = await useCase.call(tCityName);

      // assert
      verify(mockWeatherRepository. getCurrentWeather(tCityName));
      expect(result, equals(Right(tWeatherEntity)));
    },
  );

  //proses testing ketika error
  test(
    'should return [WeatherEntity] when repository failed',
    () async {
      // arrange
      when(
        mockWeatherRepository.getCurrentWeather(any)
      ).thenAnswer(
        (_) async=> const Left(NotFoundFailure('not found'))
      );

      // act
      final result = await useCase.call(tCityName);

      // assert
      verify(mockWeatherRepository. getCurrentWeather(tCityName));
      expect(result, Left(const NotFoundFailure('not found')));
    },
  );
}