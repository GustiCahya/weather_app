import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weather_app/services/location_storage_service.dart';

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
  LatLng? selectedPoint;

// Adjust the signature of _onTap to match the expected onTap callback signature
Future<void> _onTap(position, LatLng latlng) async {
  setState(() {
    selectedPoint = latlng;
  });
  // Get address from latitude and longitude
  List<Placemark> placemarks = await placemarkFromCoordinates(latlng.latitude, latlng.longitude);
  String address = "${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.postalCode}, ${placemarks.first.country}";
  print('Selected location: $latlng, Address: $address');
  
  // Prompt user for a title for the selected location
  final TextEditingController titleController = TextEditingController();
  titleController.text = placemarks.first.name ?? placemarks.first.locality ?? placemarks.first.administrativeArea ?? placemarks.first.country ?? '';
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Enter Location Title'),
        content: TextField(
          controller: titleController,
          decoration: InputDecoration(hintText: "Title"),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () {
              String title = titleController.text;
              // Save location details to local storage
              locationStorageService.saveLocation(
                title, address, latlng.latitude, latlng.longitude
              );
              print('Location saved with title: $title');
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
  );
}


  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: LatLng(-6.21154400, 106.84517200),
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
