import 'dart:async';
import 'package:flutter/material.dart';
import 'package:salat_app/models/salat_model.dart';
import 'package:salat_app/services/Myservice.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart'; // For time parsing

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Timer? _timer;
  Duration? _countdown;
  String? _nextPrayer;
  Map<String, String>? prayerTime;
  List tt = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"];
  // Fetch data
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
      prayerTime = tempo.prayerTime;
      setState(() {
        _salat = tempo;
        _startCountdown();
      });
    } catch (e) {
      // Handle error
    }
  }

  void _startCountdown() {
    if (prayerTime == null) return;

    final now = DateTime.now();
    final prayerTimes = prayerTime!.entries
        .where((test) => tt.contains(test))
        .map((entry) => MapEntry(
            entry.key,
            DateFormat('HH:mm').parse(entry.value).add(Duration(
                days: entry.value.compareTo(DateFormat('HH:mm').format(now)) < 0
                    ? 1
                    : 0)))) // Adjust for next day's prayer
        .toList();

    prayerTimes.sort((a, b) => a.value.compareTo(b.value)); // Sort by time

    final nextPrayer = prayerTimes.firstWhere(
        (entry) => entry.value.isAfter(now),
        orElse: () => prayerTimes.first);

    setState(() {
      _nextPrayer = nextPrayer.key;
      _countdown = nextPrayer.value.difference(now);
    });

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (_) => _updateCountdown());
  }

  void _updateCountdown() {
    if (_countdown == null) return;

    setState(() {
      _countdown = _countdown! - Duration(seconds: 1);
      if (_countdown!.isNegative) {
        _startCountdown(); // Restart for the next prayer
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_nextPrayer != null && _countdown != null)
              Column(
                children: [
                  Text(
                    'Next Prayer: $_nextPrayer',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${_countdown!.inHours.toString().padLeft(2, '0')}:${(_countdown!.inMinutes % 60).toString().padLeft(2, '0')}:${(_countdown!.inSeconds % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            Lottie.asset('assets/mosque.json'),
            const SizedBox(height: 20),
            Text(
              _salat?.date ?? "Loading...",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (prayerTime != null)
              ...prayerTime!.entries
                  .where((entry) => tt.contains(entry.key))
                  .map((entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          '${entry.key} : ${entry.value}',
                          style: TextStyle(fontSize: 18),
                        ),
                      )),
          ],
        ),
      ),
    );
  }
}
