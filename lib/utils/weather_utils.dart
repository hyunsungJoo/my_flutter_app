import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.dart';
import 'date_utils.dart' as dt;


class WeatherUtil {
  
  //날씨 아이콘 맵
  static const Map<WeatherDescription, IconData> weatherIcons = {
    WeatherDescription.sunny: Icons.wb_sunny,
    WeatherDescription.cloudy: Icons.wb_cloudy,
    WeatherDescription.clear: Icons.brightness_1,
    WeatherDescription.rain: Icons.umbrella,
    WeatherDescription.snow: Icons.snowboarding,
    WeatherDescription.thunder: Icons.thunderstorm
  };
  
  //날씨 정보 취득
  static String weatherDescription(Weather weather) {
    //요일 취득
    var day = dt.DateUtils.weekdays[weather.dateTime.weekday];
    var description = Weather.displayValues[weather.weatherDescription];
    return "$day, $description";
  }

  // 현재 오도 취득
  static String currentTemperature(TemperatureUnit unit, Weather temp) {
    var tempInt = temp.temperature.current;
    if (unit == TemperatureUnit.fahrenheit) {
      tempInt = Temperature.celsiusToFahrenheit(tempInt);
  }
    return '$tempInt ${WeatherUtil.temperatureLabels[unit]}';
}

// 온도 라벨
static Map<TemperatureUnit, String> temperatureLabels = {
  TemperatureUnit.celsius: "°C",
  TemperatureUnit.fahrenheit: "°F",
  };
}

