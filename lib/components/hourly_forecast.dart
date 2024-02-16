import 'package:flutter/material.dart';
import 'package:weather_app/services/api.dart';
import 'package:weather_app/services/setting_storage_service.dart';
import 'dart:convert'; // For decoding the JSON response

class HourlyForecast extends StatefulWidget {
  @override
  _HourlyForecastState createState() => _HourlyForecastState();
}

class _HourlyForecastState extends State<HourlyForecast> {
  List<Map<String, dynamic>> hourlyData = [];
  final SettingStorageService _settingStorageService = SettingStorageService();
  String _unit = 'C'; // Default unit

  @override
  void initState() {
    super.initState();
    _loadHourlyForecast();
  }

  Future<void> _loadHourlyForecast() async {
    await _settingStorageService.storage.ready; // Ensure storage is ready
    String? unit = _settingStorageService.getSetting('unit');
    if (unit != null) _unit = unit;

    String? locationJson = _settingStorageService.getSetting('location');
    double lat = -6.21154400; // Default latitude
    double lon = 106.84517200; // Default longitude
    if (locationJson != null) {
      Map<String, dynamic> location = json.decode(locationJson);
      lat = location['latitude'];
      lon = location['longitude'];
    }

    try {
      var apiService = ApiService();
      var data = await apiService.fetchHourlyWeather(lat: lat, lon: lon); // Pass latitude and longitude
      var jsonData = data; // Adjust based on actual API response
      
      setState(() {
        hourlyData = List<Map<String, dynamic>>.from(jsonData['list'].map((item) {
          var dateTime = DateTime.parse(item['dt_txt']);
          var iconUrl = item['weather'][0]['icon'];
          // Decide temperature unit
          var temp = _unit == 'F' ? item['main']['temp_fh'] : item['main']['temp'];
          return {
            'time': '${dateTime.hour}:00', // Adjust formatting as needed
            'icon': iconUrl,
            'temp': '${temp.toStringAsFixed(1)}°${_unit}',
          };
        }));
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }

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
                  Image.network(data['icon'], width: 50), // Display weather icon
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
