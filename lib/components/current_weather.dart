import 'package:flutter/material.dart';
import 'package:weather_app/services/api.dart';

class CurrentWeather extends StatefulWidget {
  @override
  _CurrentWeatherState createState() => _CurrentWeatherState();
}

class _CurrentWeatherState extends State<CurrentWeather> {
  Map<String, dynamic>? _weatherData;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    try {
      var apiService = ApiService();
      var data = await apiService.fetchCurrentWeather(lat: -6.597147, lon: 106.806038);
      setState(() {
        _weatherData = data;
      });
    } catch (e) {
      // Handle the error
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          if (_weatherData != null) ...[
            Image.network(_weatherData!['weather'][0]['icon']),
            Text(
              '${_weatherData!['main']['temp']}°',
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),
            Text(
              _weatherData!['name'],
              style: TextStyle(fontSize: 24),
            ),
            // Add more weather details here
          ] else ...[
            CircularProgressIndicator(), // Show a loader while the data is being fetched
          ]
        ],
      ),
    );
  }
}
