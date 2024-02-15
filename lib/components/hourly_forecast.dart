import 'package:flutter/material.dart';

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
