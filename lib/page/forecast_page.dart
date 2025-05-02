import 'package:flutter/material.dart';
import 'package:weather_app/controller/forecast_controller.dart';
import '../models/weather.dart';
import 'package:weather_app/utils/date_utils.dart' as dt;
import 'package:weather_app/utils/weather_utils.dart';

import 'package:weather_app/page/city_page.dart';

//날씨예보 페이지(뷰)
class ForecastPage extends StatefulWidget {

  final String title;

  // 생성자 작성
  const ForecastPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() {
    return _ForecastPageStage();
  }

}

// _의미는 비공개(private)
class _ForecastPageStage extends State<ForecastPage> {

  late final ForecastController _forecastController;
  late Future<void> _initFuture;

  String? _city = 'Seoul'; // 최초도시

  @override
  void initState() {
    super.initState();
    _loadForecast();
  }

  void _loadForecast() {
    _forecastController = ForecastController(_city!);
    _initFuture = _forecastController.init();
  }

  void _selectCity() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CityPage())
    );
    if (result != null && result != _city) {
      setState(() {
        _city = result;
        _loadForecast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError)
          return Center(child: Text("에러 발생: ${snapshot.error}"));


      final forecast = _forecastController.forecast;

        return Scaffold(
            appBar: AppBar(
              title: Text(
                _city!,
                style: Theme.of(context).textTheme.headlineLarge,),
              leading: IconButton(
                  onPressed: _selectCity,
                  icon: const Icon(Icons.location_city)),
              actions: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right:16.0),
                    child: Text(
                        WeatherUtil.temperatureLabels[TemperatureUnit.celsius]!,
                        style: TextStyle(fontSize: 22, fontWeight:  FontWeight.bold)
                    ),
                  ),
                )
              ],
              centerTitle: true,),
            body: Padding(padding:
            EdgeInsets.symmetric(vertical: 32.0),
              child: Stack(
                children: [

                  getWeatherImage(_forecastController.nowWeather.weatherDescription),

                  Positioned(
                      left: 0, right: 0, top: 100.0,
                      child:
                      Column(
                        children: [
                          Table(
                            columnWidths: const {
                              0: FixedColumnWidth(100.0),
                              2: FixedColumnWidth(30.0),
                              3: FixedColumnWidth(30.0),
                            },
                            children: forecast.days.map((day) {
                              Weather dailyWeather = day.hourlyWeather[0];

                              return TableRow(
                                  children: [
                                    TableCell(child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                          dt.DateUtils.weekdays[dailyWeather
                                              .dateTime.weekday]!),)),
                                    TableCell(child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child:
                                      Icon(WeatherUtil.weatherIcons[dailyWeather
                                          .weatherDescription])
                                      ,)),
                                    TableCell(child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(day.max.toString()),)),
                                    TableCell(child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(day.min.toString()),))
                                  ]
                              );
                            }).toList(),
                          )
                        ],
                      )),
                  Positioned(
                      left: 0, right: 0, top: 0,
                      child:
                      Padding(padding: EdgeInsets.only(bottom: 12.0),
                          child: Column(
                            children: <Widget>[
                              Text(WeatherUtil.weatherDescription(
                                  _forecastController.nowWeather),
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .headlineLarge,),
                              Text(WeatherUtil.currentTemperature(
                                  TemperatureUnit.celsius,
                                  _forecastController.nowWeather),
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .displayLarge,)
                            ],
                          ))),
                ],
              )
              ,
            )
        );

  }

  );


}

}

Widget getWeatherImage(WeatherDescription description) {
  switch (description) {
    case WeatherDescription.clear:
      return Positioned(
          left: 50, top: 50,
          child: Image.asset('assets/images/sun.png',
              width: 150, height: 150));
    case WeatherDescription.sunny:
      return Stack(
        children: [
          Positioned(
            left: 50.0, top: 50.0,
            child: Image.asset('assets/images/sun.png', width: 150.0, height: 150.0),
          ),
          Positioned(
            left: 50.0, top: 120.0,
            child: Image.asset('assets/images/cloud.png', width: 200.0, height: 100.0),
          ),
        ],
      );
    case WeatherDescription.cloudy:
      return Positioned(
          left: 50, top: 120,
          child: Image.asset('assets/images/cloud.png',
              width: 200, height: 100));
    case WeatherDescription.rain:
      return Stack(
          children: [
            Positioned(
                left: 50, top: 120,
                child: Image.asset('assets/images/cloud.png',
                    width: 200, height: 100)),
            Positioned(
                left: 100, top: 200,
                child: Image.asset('assets/images/rain.png',
                    width: 100, height: 100))
          ]
      );
    case WeatherDescription.snow:
      return Positioned(
          left: 50, top: 120,
          child: Image.asset('assets/images/snow.png',
              width: 200, height: 100));
    case WeatherDescription.thunder:
      return Stack(
          children: [
            Positioned(
                left: 50, top: 50,
                child: Image.asset('assets/images/cloud.png',
                    width: 200, height: 100)),
            Positioned(
                left: 100, top: 150,
                child: Image.asset('assets/images/thunder.png',
                    width: 100, height: 100))
          ]
      );
  }
}
