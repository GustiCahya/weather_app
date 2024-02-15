import 'package:localstorage/localstorage.dart';
import 'dart:convert';

class LocationStorageService {
  final LocalStorage storage = LocalStorage('locations2.json');

  void saveLocation(
      String title, String address, double latitude, double longitude) async {
    await storage.ready; // Ensure storage is ready
    List<dynamic> locations = jsonDecode(storage.getItem('locations') ?? '[]');
    Map<String, dynamic> locationData = {
      'title': title,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
    locations.add(locationData);

    // Check if locations list exceeds 7 entries, if so, remove the first one
    if (locations.length > 7) {
      locations.removeAt(0);
    }

    storage.setItem('locations', jsonEncode(locations));
  }

  List<dynamic>? loadLocations() {
    String? locationsDataString = storage.getItem('locations');
    if (locationsDataString != null) {
      return jsonDecode(locationsDataString);
    }
    return [];
  }

  void deleteLocation(int index) {
    List<dynamic> locations = jsonDecode(storage.getItem('locations') ?? '[]');
    locations.removeAt(index);
    storage.setItem('locations', jsonEncode(locations));
  }

  // Inside LocationStorageService
  bool titleExists(String title) {
    List<dynamic> locations = jsonDecode(storage.getItem('locations') ?? '[]');
    for (var location in locations) {
      if (location['title'] == title) {
        return true;
      }
    }
    return false;
  }
}
