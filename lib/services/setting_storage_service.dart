import 'package:localstorage/localstorage.dart';
import 'dart:convert';

class SettingStorageService {
  final LocalStorage storage = LocalStorage('setting_weather_app');

  void saveSetting(String key, String value) {
    storage.setItem(key, value);
  }

  String? getSetting(String key) {
    return storage.getItem(key);
  }

  Map<String, dynamic>? getSavedLocation() {
    String? locationJson = getSetting('location');
    if (locationJson != null) {
      return json.decode(locationJson);
    }
    return null;
  }

}
