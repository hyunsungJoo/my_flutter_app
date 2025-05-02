import "package:weather_app/models/weather_service.dart";

void main() async {
  WeatherService weatherService = WeatherService(); // 객체 생성

  Future<List<dynamic>> myFuture
    = weatherService.fetchWeeklyWeather("seoul"); // inchon, osaka, sapporo

  await myFuture.then((list) {
    for (dynamic weather in list) {
      print("temp: ${weather['main']['temp']}");
    }
  });
}