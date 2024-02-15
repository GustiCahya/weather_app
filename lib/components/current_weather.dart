import 'package:flutter/material.dart';
import 'package:weather_app/services/api.dart';
import 'package:weather_app/services/setting_storage_service.dart';
import 'dart:convert'; // Import json for decoding stored settings

class CurrentWeather extends StatefulWidget {
  @override
  _CurrentWeatherState createState() => _CurrentWeatherState();
}

class _CurrentWeatherState extends State<CurrentWeather> {
  Map<String, dynamic>? _weatherData;
  final SettingStorageService _settingStorageService = SettingStorageService();
  String _unit = 'C'; // Default unit
  String? title = '';

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    await _settingStorageService.storage.ready; // Ensure storage is ready
    String? locationJson = _settingStorageService.getSetting('location');
    String? unit = _settingStorageService.getSetting('unit');
    double lat = -6.21154400; // Default latitude
    double lon = 106.84517200; // Default longitude
    if (locationJson != null) {
      Map<String, dynamic> location = json.decode(locationJson);
      lat = location['latitude'];
      lon = location['longitude'];
      title = location['title'];
    }
    if (unit != null) _unit = unit;

    try {
      var apiService = ApiService();
      var data = await apiService.fetchCurrentWeather(lat: lat, lon: lon);
      setState(() {
        _weatherData = data;
        // Optionally adjust temperature based on unit
        if (_unit == 'F') {
          _weatherData!['main']['temp'] = _weatherData!['main']['temp_fh'];
        }
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
              '${_weatherData!['main']['temp']}°${_unit == 'F' ? 'F' : 'C'}', // Adjust display based on unit
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),
            Text(
              title ?? _weatherData!['name'],
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
