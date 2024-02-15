import 'dart:convert';
import 'package:http/http.dart' as http;

String url = "http://159.223.73.64:3000";

class ApiService {
  Future<Map<String, dynamic>> fetchCurrentWeather({required double lat, required double lon}) async {
    final uri = Uri.parse('$url/v1/weather/current?lat=$lat&lon=$lon');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
