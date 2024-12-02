import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import 'package:permission_handler/permission_handler.dart';

class Myservice {
  final serv = Myservice();

  Future<double?> getLat() async {
    return serv.getLat();
  }

  Future<double?> getLong() async {
    return serv.getLong();
  }

  Future<List<Map<String, dynamic>>?> getMosquesNearby(
      double latitude, double longitude) async {
    const double radius = 0.01; // Approx 1km radius
    final double latMin = latitude - radius;
    final double latMax = latitude + radius;
    final double lonMin = longitude - radius;
    final double lonMax = longitude + radius;

    final query = """
    [out:json];
    node["amenity"="place_of_worship"]["religion"="muslim"]
    ($latMin,$lonMin,$latMax,$lonMax);
    out;
    """;

    final url =
        Uri.parse('https://overpass-api.de/api/interpreter?data=$query');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List mosques = data['elements'];

        return mosques
            .map((mosque) => {
                  'lat': mosque['lat'],
                  'lon': mosque['lon'],
                  'name': mosque['tags']?['name'] ?? 'Unknown Mosque',
                })
            .toList();
      } else {
        print('Failed to fetch mosques: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      e.toString();
      return null;
    }
  }
}
