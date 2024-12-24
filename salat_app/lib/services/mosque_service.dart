// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:salat_app/services/Myservice.dart';

class MosqueService {
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
        return null;
      }
    } catch (e) {
      e.toString();
      return null;
    }
  }

  Future<List<LatLng>?> getRouteToMosque(
      double startLat, double startLon, double endLat, double endLon) async {
    final url = Uri.parse(
        'https://routing.openstreetmap.de/routed-car/route/v1/driving/$startLon,$startLat;$endLon,$endLat?overview=full&geometries=polyline');

    try {
      print('Fetching route from: $url'); // Debugging
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('Route data: ${response.body}'); // Print the response
        final data = jsonDecode(response.body);
        final polyline = data['routes'][0]['geometry'];
        return decodePolyline(polyline);
      } else {
        print('Failed to fetch route: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching route: $e');
      return null;
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }
}
