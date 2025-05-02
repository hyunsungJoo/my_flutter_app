import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = "f915ecd2cd001e998edfa294889c880d";
  final String apiUrl = "https://api.openweathermap.org/data/2.5/forecast";

  Future<List<dynamic>> fetchWeeklyWeather(String city) async {
    final response = await http.get(Uri.parse(
      '$apiUrl?q=$city&units=metric&appid=$apiKey'
    ));

    if(response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['list'];
    } else {
      throw Exception("오픈웨더맵 불가");
    }
  }
}