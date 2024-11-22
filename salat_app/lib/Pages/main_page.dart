import 'dart:async';

import 'package:flutter/material.dart';
import 'package:salat_app/Pages/countdown_to_nearest_time.dart';
import 'package:salat_app/models/salat_model.dart';
import 'package:salat_app/services/Myservice.dart';
import 'package:lottie/lottie.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Map<String, String>? prayerTime;
  //fetch data
  Salat? _salat;
  final _myService = Myservice();

  Future<String> getData() {
    return _myService.getCurrentCity();
  }

  _fetchData() async {
    String city = await _myService.getCurrentCity();
    String country = await _myService.getCurrentCountry();

    try {
      final tempo = await _myService.getSalatTime(city, country);
      prayerTime = tempo!.prayerTime;
      setState(() {
        _salat = tempo;
      });
    } catch (e) {
      //
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchData();
  }

  List tt = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"];
  @override
  Widget build(BuildContext context) {
    final tt = [
      'Fajr',
      'Dhuhr',
      'Asr',
      'Maghrib',
      'Isha'
    ]; // Example prayer keys
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 105,
              child: CountdownToNearestTime(prayerTime!),
            ),
            Lottie.asset('assets/mosque.json'),
            Text(_salat?.date ?? "loading"),
            ...?prayerTime?.entries
                .where((entry) => tt.contains(entry.key))
                .map(
                  (entry) => Column(
                    children: [
                      Text(
                        '${entry.key} : ${entry.value}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
