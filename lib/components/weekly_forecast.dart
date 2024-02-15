import 'package:flutter/material.dart';

class WeeklyForecast extends StatelessWidget {
  // Dummy data for weekly forecast
  final List<Map<String, dynamic>> weeklyData = [
    {'day': 'Hari ini', 'temp': '29.23°', 'icon': Icons.wb_sunny},
    // Add more entries here...
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: weeklyData.map((data) {
        return ListTile(
          leading: Icon(data['icon']),
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
                  value: 20, // Assuming a static value for demonstration
                  min: 10,
                  max: 30,
                  onChanged: null, // This disables the slider
                ),
              ),
              Text(data['temp']), // Temperature data
            ],
          ),
        );
      }).toList(),
    );
  }
}
