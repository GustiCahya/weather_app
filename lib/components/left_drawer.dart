import 'package:flutter/material.dart';
import 'package:weather_app/components/map_component.dart';
import 'package:weather_app/services/location_storage_service.dart';
import 'package:weather_app/services/setting_storage_service.dart';
import 'package:weather_app/main.dart';
import 'dart:convert';

class LeftDrawer extends StatefulWidget {
  @override
  _LeftDrawerState createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  final SettingStorageService _settingStorageService = SettingStorageService();
  final LocationStorageService _storageService = LocationStorageService();
  late List<dynamic> _locations;

  @override
  void initState() {
    super.initState();
    _locations = _storageService.loadLocations() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView( // Using ListView for better scrolling behavior
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MapComponentPage()),
              );
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 20), // Adjust padding for positioning
              child: Container(
                height: 48, // Standard height for text fields
                decoration: BoxDecoration(
                  color: Colors.green[100], // Light grey color for the input field
                  borderRadius: BorderRadius.circular(24), // Rounded corners
                ),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(Icons.map, color: Colors.grey[600]), // Darker grey icon
                    ),
                    Text(
                      'Temukan Lokasi',
                      style: TextStyle(color: Colors.grey[600]), // Darker grey text
                    ),
                  ],
                ),
              ),
            ),
          ),
          ..._locations.map((location) {
            int index = _locations.indexOf(location);
            return Dismissible(
              key: Key(location['title']),
              onDismissed: (direction) {
                _storageService.deleteLocation(index);
                setState(() {
                  _locations.removeAt(index);
                });
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight, // Align the trash icon to the right
                padding: EdgeInsets.only(right: 20.0), // Add some padding to the right
                child: Icon(Icons.delete, color: Colors.white), // Trash icon with white color
              ),
              child: ListTile(
                leading: Icon(Icons.location_city),
                title: Text(location['title']),
                subtitle: Text(location['address']),
                onTap: () {
                  // Convert the location map to a JSON string to store in local storage.
                  String locationJson = jsonEncode({
                    'title': location['title'],
                    'address': location['address'],
                    'latitude': location['latitude'],
                    'longitude': location['longitude'],
                  });

                  // Save this location as the current location in settings.
                  _settingStorageService.saveSetting('location', locationJson);

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MyWeatherApp()),
                  );
                },
              ),
            );
          }).toList(),
          Divider(),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Tambah lokasi'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MapComponentPage()),
              );
            },
          )
        ],
      ),
    );
  }
}
