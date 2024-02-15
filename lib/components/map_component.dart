import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weather_app/services/location_storage_service.dart';
import 'package:weather_app/services/setting_storage_service.dart';
import 'package:weather_app/main.dart';
import 'dart:convert';

class MapComponentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Lokasi'),
      ),
      body: MapComponent(),
    );
  }
}

class MapComponent extends StatefulWidget {
  @override
  _MapComponentState createState() => _MapComponentState();
}

class _MapComponentState extends State<MapComponent> {
  MapController mapController = MapController();
  final LocationStorageService locationStorageService =
      LocationStorageService();
  final SettingStorageService settingStorageService = SettingStorageService();
  LatLng? selectedPoint;
  LatLng mapCenter = LatLng(-6.21154400, 106.84517200); // Default center

  @override
  void initState() {
    super.initState();
    _loadSavedLocation();
  }

  void _loadSavedLocation() {
    Map<String, dynamic>? savedLocation =
        settingStorageService.getSavedLocation();
    if (savedLocation != null &&
        savedLocation['latitude'] != null &&
        savedLocation['longitude'] != null) {
      setState(() {
        double latitude = savedLocation['latitude'] is int
            ? (savedLocation['latitude'] as int).toDouble()
            : savedLocation['latitude'];
        double longitude = savedLocation['longitude'] is int
            ? (savedLocation['longitude'] as int).toDouble()
            : savedLocation['longitude'];
        mapCenter = LatLng(latitude, longitude);
      });
    }
  }

  // Adjust the signature of _onTap to match the expected onTap callback signature
  Future<void> _onTap(position, LatLng latlng) async {
    setState(() {
      selectedPoint = latlng;
    });
    // Get address from latitude and longitude
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latlng.latitude, latlng.longitude);
    String address =
        "${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.postalCode}, ${placemarks.first.country}";
    print('Selected location: $latlng, Address: $address');

    // Prompt user for a title for the selected location
    final TextEditingController titleController = TextEditingController();
    titleController.text = placemarks.first.locality ??
        placemarks.first.administrativeArea ??
        placemarks.first.country ??
        '';
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Masukkan Nama Lokasi'),
            content: TextField(
              controller: titleController,
              decoration: InputDecoration(hintText: "Nama Lokasi"),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Batalkan'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
// Inside _onTap method of _MapComponentState
              TextButton(
                child: Text('Simpan'),
                onPressed: () {
                  String title = titleController.text.trim();
                  if (title.isEmpty) {
                    // Optionally, inform the user the title cannot be empty.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Nama lokasi tidak boleh kosong")),
                    );
                    return; // Exit if the title is empty
                  }

                  bool exists = locationStorageService.titleExists(title);
                  if (!exists) {
                    // Save location details to local storage if title does not exist
                    locationStorageService.saveLocation(
                        title, address, latlng.latitude, latlng.longitude);
                    Map<String, dynamic> locationData = {
                      'title': title,
                      'address': address,
                      'latitude': latlng.latitude,
                      'longitude': latlng.longitude,
                    };
                    settingStorageService.saveSetting(
                        'location', jsonEncode(locationData));
                    print('Location saved with title: $title');
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => MyWeatherApp()),
                    );
                  } else {
                    // Inform the user that the title already exists
                    Navigator.of(context).pop(); // Close the dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              "Nama lokasi ini sudah pernah ditambahkan sebelumnya")),
                    );
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => MyWeatherApp()),
                    );
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center:
            mapCenter, //! Map setting_storage_service location latitude and longitude in here
        zoom: 13.0,
        onTap: _onTap, // Pass the _onTap method correctly
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        if (selectedPoint != null)
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: selectedPoint!,
                builder: (ctx) => Container(
                  child: Icon(Icons.location_pin, color: Colors.red),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
