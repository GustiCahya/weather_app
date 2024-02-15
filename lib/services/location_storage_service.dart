import 'package:localstorage/localstorage.dart';
import 'dart:convert';

class LocationStorageService {
  final LocalStorage storage = LocalStorage('app_storage.json');

  void saveLocation(String title, String address, double latitude, double longitude) {
    // Create a map to store location details
    Map<String, dynamic> locationData = {
      'title': title,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
    // Convert map to string using jsonEncode
    storage.setItem('location', jsonEncode(locationData));
    print('Location saved: $title, $address, $latitude, $longitude');
  }

  Map<String, dynamic>? loadLocation() {
    // Retrieve the saved location data
    String? locationDataString = storage.getItem('location');
    if (locationDataString != null) {
      return jsonDecode(locationDataString);
    }
    return null;
  }
}
