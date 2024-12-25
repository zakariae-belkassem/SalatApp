import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:salat_app/Pages/countdown_to_nearest_time.dart';
import 'package:salat_app/models/salat_model.dart';
import 'package:salat_app/services/Myservice.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Map<String, String>? prayerTime;
  // Fetch data
  Salat? _salat;
  final _myService = Myservice();
  bool _showCountdown = false;

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
        _showCountdown = true;
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

  List<String> tt = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prayer Times"),
        titleTextStyle: TextStyle(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      body: Container(
        color: Colors.grey[850],
        child: Column(
          children: [
            // Header with location and date
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(),
                    ],
                  ),
                ],
              ),
            ),
            // Countdown section
            SizedBox(
              height: 105,
              child: Center(
                child: _showCountdown
                    ? CountdownToNearestTime(prayerTime!)
                    : LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white, size: 50),
              ),
            ),
            // Date display
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _salat?.date ?? "",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // List of prayer times
            Expanded(
              child: ListView(
                children: prayerTime?.entries
                        .where((entry) => tt.contains(entry.key))
                        .map(
                          (entry) => ListTile(
                            leading:
                                const Icon(Icons.timelapse, color: Colors.grey),
                            title: Text(
                              entry.key,
                              style: const TextStyle(color: Colors.white),
                            ),
                            trailing: Text(
                              entry.value,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                        .toList() ??
                    [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
