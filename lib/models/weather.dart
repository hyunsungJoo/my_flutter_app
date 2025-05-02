// 기상예보(일주일)
class Forecast {
  final String city;
  final List<ForecastDay> days;

  Forecast({required this.city, required this.days});
}

// 기상예보(하루)
class ForecastDay {
  final List<Weather> hourlyWeather; // 3사건 단위 날씨
  final DateTime date; // 현재 날짜
  final int min; // 최저 온도
  final int max; // 최고 온도

  ForecastDay({required this.hourlyWeather,
            required this.date, required this.min,
            required this.max});

  static Weather getWeatherForHour(ForecastDay self, int hour) {
    return self.hourlyWeather.reduce((a, b) {
      int diffA = (a.dateTime.hour - hour).abs();
      int diffB = (a.dateTime.hour - hour).abs();
      return diffA <= diffB ? a : b;
    });
  }
}

// 날씨
class Weather {
  final String city; // 현재 날짜
  final DateTime dateTime; // 최저 온도
  final Temperature temperature; // 최고 온도
  final WeatherDescription weatherDescription;
  final String weatherIcon;

  Weather({required this.city, required this.dateTime,
          required this.temperature, required this.weatherDescription,
          required this.weatherIcon});

  static Map<WeatherDescription, String> displayValues = {
    WeatherDescription.clear: "청명",
    WeatherDescription.cloudy: "흐림",
    WeatherDescription.rain: "비",
    WeatherDescription.sunny: "맑음",
    WeatherDescription.snow: "눈",
    WeatherDescription.thunder: "천둥",
  };
}

// 온도
class Temperature {
  final int current;
  final TemperatureUnit temperatureUnit;

  //섭씨를 화씨로 변경
  static int celsiusToFahrenheit(int temp) => (temp * 9 /5 + 32).floor();

  Temperature({required this.current, this.temperatureUnit =
    TemperatureUnit.celsius});
}

// 온도 단위
enum TemperatureUnit { celsius, fahrenheit}

// 날씨설명
enum WeatherDescription { clear, cloudy, sunny, rain, snow, thunder }