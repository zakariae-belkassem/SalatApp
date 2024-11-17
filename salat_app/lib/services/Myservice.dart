import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:salat_app/models/salat_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Myservice {
  //http://api.aladhan.com/v1/timingsByCity/DD-MM-YYYY?country=0000&city=0000"
  //get current date : http://api.aladhan.com/v1/currentDate
  static const BASE_URL = "http://api.aladhan.com/v1/timingsByCity";

  Myservice();

  Future<Salat> getSalatTime(String cityName, String country) async {
    var now = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    final response = await http.get(
        Uri.parse('$BASE_URL/$formattedDate?country=$country&city=$cityName'));
    if (response.statusCode == 200) {
      Salat temp = Salat.fromJson(jsonDecode(response.body));
      temp.cityName = cityName;
      return temp;
    }
    throw Exception("Failed to fetch from server please try again later");
  }

  Future<String> getCurrentCity() async {
    LocationPermission perm = await Geolocator.checkPermission();

    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);

    String? city = placemarks[0].locality;

    return city ?? "Rabat";
  }

  Future<String> getCurrentCountry() async {
    LocationPermission perm = await Geolocator.checkPermission();

    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);

    String? city = placemarks[0].country;

    return city ?? "Morocco";
  }
}
