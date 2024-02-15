import 'package:flutter/material.dart';

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
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.grey, // Active part of the slider
                  inactiveTrackColor: Colors.grey[300], // Inactive part of the slider
                  thumbColor: Colors.grey, // Color of the slider thumb
                  overlayColor: Colors.grey.withAlpha(32), // Color of the halo effect
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0), // Thumb shape and size
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0), // Halo shape and size
                ),
                child: Slider(
                  value: 20,
                  min: 10,
                  max: 30,
                  onChanged: (newRating) {},
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
