import 'package:weather_app/models/weather.dart';
import 'package:weather_app/models/weather_service.dart';
import 'package:weather_app/utils/string_utils.dart';
import 'dart:math' as math;

class ForecastController {
  final String _city; // 어느 도시 날씨인지?
  late Forecast forecast; // 일주일간의 일기예뽀
  late Weather nowWeather; // 현재 날씨

  ForecastController(this._city);

  Future<void> init() async {

    final weatherService = WeatherService();
    final rawList = await weatherService.fetchWeeklyWeather(this._city);

    Map<String, List<dynamic>> groupedByDate = {};

    for(var item in rawList){
      DateTime dt = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String dateKey = "${dt.year}-${twoDigits(dt.month)}-${twoDigits(dt.day)}";
      groupedByDate.putIfAbsent(dateKey, () => []).add(item);
    }

    DateTime now = DateTime.now();
    List<ForecastDay> sevenDaysForecast = [];

    groupedByDate.forEach((dateStr, items) { //2025-04-39, ...
      List<Weather> forecasts = []; // 3시간 단위별 날씨
      double minTemp = double.infinity;
      double maxTemp = double.negativeInfinity;

      for(var item in items) {
        DateTime dt = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
        double temp = (item['main']['temp'] as num).toDouble();
        double min = (item['main']['temp_min'] as num).toDouble();
        double max = (item['main']['temp_max'] as num).toDouble();
        String desc = item['weather'][0]['main'].toString();
        String icon = item['weather'][0]['icon'];

        // enum 매핑 처러
        WeatherDescription description = WeatherDescription.clear;
        if(desc.containsIgnoreCase("Clouds")) {
          description = WeatherDescription.cloudy;
        } else if (desc.containsIgnoreCase("Rain")) {
          description = WeatherDescription.rain;
        } else if (desc.containsIgnoreCase("Clear")) {
          description = WeatherDescription.clear;
        } else if (desc.containsIgnoreCase("Snow")) {
          description = WeatherDescription.snow;
        } else if (desc.containsIgnoreCase("Thunder")) {
          description = WeatherDescription.thunder;
        }

        forecasts.add(Weather(city: _city, dateTime: dt,
            temperature: Temperature(current: temp.round()),
            weatherDescription: description, weatherIcon: icon));

        minTemp = math.min(minTemp, min);
        maxTemp = math.max(maxTemp, max);
      }

      final parsedDate = DateTime.parse(dateStr);
      sevenDaysForecast.add(ForecastDay(hourlyWeather: forecasts,
          date: parsedDate, min: minTemp.round(), max: maxTemp.round()));
    });

    // 날짜 오름차순 정렬
    sevenDaysForecast.sort((a, b) => a.date.compareTo(b.date));

    forecast = Forecast(city: _city, days: sevenDaysForecast);
    ForecastDay nowDay = forecast.days[0]; // 현재 날씨
    nowWeather = ForecastDay.getWeatherForHour(nowDay, now.hour);
  }
}