import 'package:flutter/material.dart';
import 'package:weather_app/services/api.dart';
import 'package:weather_app/services/setting_storage_service.dart';
import 'dart:convert'; 
import 'package:intl/intl.dart';
import 'dart:math' as math;

class DailyForecast extends StatefulWidget {
  @override
  _DailyForecastState createState() => _DailyForecastState();
}

class _DailyForecastState extends State<DailyForecast> {
  List<Map<String, dynamic>> dailyData = [];
  final SettingStorageService _settingStorageService = SettingStorageService();
  String _unit = 'C'; // Default unit
  double min = 0;
  double max = 0;

  @override
  void initState() {
    super.initState();
    _loadDailyForecast();
  }

  Future<void> _loadDailyForecast() async {
    await _settingStorageService.storage.ready;
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
      var data = await apiService.fetchDailyWeather(lat: lat, lon: lon); // Adjust this call as necessary
      var jsonData = data; // Assuming 'data' is a JSON string
      
      setState(() {
        dailyData = List<Map<String, dynamic>>.from(jsonData['list'].map((item) {
          DateTime date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
          String dayOfWeek = DateFormat('EEEE').format(date); // Requires intl package for DateFormat
          var temp = _unit == 'F' ? item['main']['temp_fh'] : item['main']['temp'];
          min = _unit == 'F' ? -43.6 : -4.2;
          max = _unit == 'F' ? 136 : 57.8;
          var iconCode = item['weather'][0]['icon'];
          return {
            'day': dayOfWeek,
            'temp': '${temp.toStringAsFixed(1)}°${_unit}',
            'originalTemp': temp,
            'icon': 'https://openweathermap.org/img/wn/$iconCode@2x.png',
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
    return Column(
      children: dailyData.map((data) {
        return ListTile(
          leading: Image.network(data['icon'], width: 50), // Display weather icon from URL
          title: Text(data['day']),
          trailing: Row(
            mainAxisSize: MainAxisSize.min, // Important to prevent overflow
            children: <Widget>[
              // Adjusted SliderTheme with disabled slider
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                  thumbColor: Colors.grey,
                  overlayColor: Colors.transparent,
                  disabledActiveTrackColor: Colors.grey,
                  disabledInactiveTrackColor: Colors.grey[300],
                  disabledThumbColor: Colors.grey,
                ),
                child: Slider(
                  value: (data['originalTemp'] as num).toDouble().clamp(min, max),
                  min: min,
                  max: max,
                  onChanged: null, // This disables the slider
                ),
              ),
              Text(data['temp']), // Temperature data
            ],
          ), // Temperature data
        );
      }).toList(),
    );
  }
}
