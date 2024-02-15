import 'package:flutter/material.dart';

class WeeklyForecast extends StatelessWidget {
  // Dummy data for weekly forecast
  final List<Map<String, dynamic>> weeklyData = [
    {'day': 'Hari ini', 'temp': '29.23°', 'icon': Icons.wb_sunny},
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
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  // Customize the theme for active appearance even when disabled
                  activeTrackColor: Colors.grey, // Active part of the slider
                  inactiveTrackColor: Colors.grey[300], // Inactive part of the slider
                  thumbColor: Colors.grey, // Color of the slider thumb
                  overlayColor: Colors.transparent, // Remove overlay color
                  disabledActiveTrackColor: Colors.grey, // Use for a disabled but "active-looking" track
                  disabledInactiveTrackColor: Colors.grey[300], // Same as above for the inactive part
                  disabledThumbColor: Colors.grey, // Thumb color even when disabled
                ),
                child: const Slider(
                  value: 20,
                  min: 10,
                  max: 30,
                  onChanged: null, // This disables the slider
                ),
              ),
              Text(data['temp']),
            ],
          ),
        );
      },
    );
  }
}
