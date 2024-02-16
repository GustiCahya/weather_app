import 'package:flutter/material.dart';
import 'package:weather_app/components/current_weather.dart';
import 'package:weather_app/components/hourly_forecast.dart';
import 'package:weather_app/components/daily_forecast.dart';
import 'package:weather_app/components/left_drawer.dart';
import 'package:weather_app/components/right_drawer.dart';
import 'package:weather_app/utils/date_utils.dart';
import 'package:weather_app/components/map_component.dart';
import 'package:localstorage/localstorage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';
import 'dart:async';
import 'package:weather_app/services/location_storage_service.dart';
import 'package:weather_app/services/setting_storage_service.dart';

class InitializationScreen extends StatefulWidget {
  @override
  _InitializationScreenState createState() => _InitializationScreenState();
}

class _InitializationScreenState extends State<InitializationScreen> {
  final LocalStorage locationsStorage = LocalStorage('locations2.json');
  final LocalStorage settingStorage = LocalStorage('setting_weather_app');

  @override
  void initState() {
    super.initState();
    _initializeStorage();
  }

  Future<void> _initializeStorage() async {
    await Future.wait([
      locationsStorage.ready,
      settingStorage.ready,
    ]);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => WeatherHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Display a loading indicator or splash screen here if desired
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

void main() {
  runApp(MyWeatherApp());
}

class MyWeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: ThemeMode.dark, // Use dark theme
      home: InitializationScreen(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final LocationStorageService locationStorageService =
      LocationStorageService();
  final SettingStorageService settingStorageService = SettingStorageService();
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _getCurrentLocation();
    _setupRefreshTimer();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permission denied');
    } else if (permission == LocationPermission.deniedForever) {
      print('Location permission permanently denied');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      String address =
          "${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.postalCode}, ${placemarks.first.country}";
      String title = placemarks.first.locality ??
          placemarks.first.administrativeArea ??
          placemarks.first.country ??
          '';

      // Convert the location map to a JSON string to store in local storage.
      String locationJson = jsonEncode({
        'title': title,
        'address': address,
        'latitude': position.latitude,
        'longitude': position.longitude,
      });

      // Save this location as the current location in settings.
      if (settingStorageService.getSavedLocation() == null) {
        settingStorageService.saveSetting('location', locationJson);
      }
      // Assuming saveLocation expects a Future to be returned, adjust if necessary.
      if (!locationStorageService.titleExists(title)) {
        locationStorageService.saveLocation(
            title, address, position.latitude, position.longitude);
      }

      // Optionally, update the UI or show a message.
      print("Current location saved: $title, $address");
    } catch (e) {
      print("Failed to get current location: $e");
      // Handle failure when location services are disabled, permissions are denied, etc.
    }
  }

  Future<void> _setupRefreshTimer() async {
    await settingStorageService.storage.ready; // Ensure storage is ready
    String? refreshRate = settingStorageService.getSetting('refresh_rate');
    
    Duration duration = const Duration(hours: 1); // Default to 1 hour if setting is not found or recognized

    if (refreshRate == 'Setiap jam') {
      duration = const Duration(hours: 1);
    } else if (refreshRate == 'Setiap 3 jam') {
      duration = const Duration(hours: 3);
    } else if (refreshRate == 'Setiap 6 jam') {
      duration = const Duration(hours: 6);
    }

    _refreshTimer = Timer.periodic(duration, (Timer t) => _refreshContent());
  }

  void _refreshContent() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MyWeatherApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Text(formatDate()),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MapComponentPage()),
              );
            },
          ),
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ],
      ),
      drawer: LeftDrawer(),
      endDrawer: RightDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshContent();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              CurrentWeather(),
              HourlyForecast(),
              DailyForecast(),
            ],
          ),
        ),
      ),
    );
  }
}
