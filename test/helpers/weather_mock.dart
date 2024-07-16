import 'package:mockito/annotations.dart';
import 'package:weather_forecast/feature/weather/domain/repositories/weather_repository.dart';
import 'package:http/http.dart' as http;

@GenerateNiceMocks([
  //berupa list jd pakai mockspec
  //tiruan dari weather repository
  MockSpec<WeatherRepository>(as: #MockWeatherRepository), 
  MockSpec<http.Client>(as: #MockHttpClient), 
])
void main() {

}