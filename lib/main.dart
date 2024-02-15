import 'package:flutter/material.dart';
import 'package:weather_app/components/current_weather.dart';
import 'package:weather_app/components/hourly_forecast.dart';
import 'package:weather_app/components/weekly_forecast.dart';
import 'package:weather_app/components/left_drawer.dart';
import 'package:weather_app/components/right_drawer.dart';
import 'package:weather_app/utils/date_utils.dart';
import 'package:weather_app/components/map_component.dart';

void main() {
  runApp(MyWeatherApp());
}

class MyWeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: ThemeMode.dark, // Use dark theme
      home: WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Text(formatDate()),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MapComponentPage()),
              );
            },
          ),
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ],
      ),
      drawer: LeftDrawer(),
      endDrawer: RightDrawer(),
      body: Column(
        children: <Widget>[
          CurrentWeather(),
          HourlyForecast(),
          Expanded(child: WeeklyForecast()),
        ],
      ),
    );
  }
}
