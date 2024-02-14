import 'package:flutter/material.dart';

void main() {
  runApp(MyWeatherApp());
}

class MyWeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: Text('Minggu, 23 July'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
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

class CurrentWeather extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Text(
            '24°',
            style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
          ),
          Text(
            'Bogor',
            style: TextStyle(fontSize: 24),
          ),
          // Add weather icon here
        ],
      ),
    );
  }
}

class HourlyForecast extends StatelessWidget {
  // Dummy data for hourly forecast
  final List<Map<String, dynamic>> hourlyData = [
    {'time': '13:30', 'temp': '19°', 'icon': Icons.wb_sunny},
    // Add more entries here...
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hourlyData.length,
        itemBuilder: (context, index) {
          var data = hourlyData[index];
          return Card(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  Text(data['time']),
                  Icon(data['icon']),
                  Text(data['temp']),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class WeeklyForecast extends StatelessWidget {
  // Dummy data for weekly forecast
  final List<Map<String, dynamic>> weeklyData = [
    {'day': 'Hari ini', 'temp': '24°', 'icon': Icons.wb_sunny},
    // Add more entries here...
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: weeklyData.length,
      itemBuilder: (context, index) {
        var data = weeklyData[index];
        return ListTile(
          leading: Icon(data['icon']),
          title: Text(data['day']),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Slider(
                value: 20,
                min: 10,
                max: 30,
                onChanged: (newRating) {},
              ),
              Text(data['temp']),
            ],
          ),
        );
      },
    );
  }
}
