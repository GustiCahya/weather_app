import 'package:localstorage/localstorage.dart';

class LocalStorageService {
  final LocalStorage storage = LocalStorage('weather_app');

  void saveSetting(String key, String value) {
    storage.setItem(key, value);
  }

  String? getSetting(String key) {
    return storage.getItem(key);
  }
}
