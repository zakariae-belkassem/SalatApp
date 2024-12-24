import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class CountdownToNearestTime extends StatefulWidget {
  final Map<String, String> time;
  const CountdownToNearestTime(this.time, {super.key});
  @override
  // ignore: no_logic_in_create_state
  createState() => _CountdownToNearestTimeState(time);
}

class _CountdownToNearestTimeState extends State<CountdownToNearestTime> {
  Map<String, String> time;
  List tt = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"];
  _CountdownToNearestTimeState(this.time);
  Timer? _timer;
  Duration _timeRemaining = Duration.zero;
  String? _nextTimeKey;

  @override
  void initState() {
    super.initState();
    _calculateNearestTime();
    _startTimer();
  }

  void _calculateNearestTime() {
    final now = DateTime.now();
    DateTime? nearestTime;
    String? nearestKey;

    time.forEach((key, value) {
      if (!tt.contains(key)) {
        return;
      }
      final split = value.split(":");
      final targetTime = DateTime(now.year, now.month, now.day,
          int.parse(split[0]), int.parse(split[1]));

      // Adjust for times that have already passed today
      final adjustedTargetTime = targetTime.isBefore(now)
          ? targetTime.add(Duration(days: 1))
          : targetTime;

      if (nearestTime == null || adjustedTargetTime.isBefore(nearestTime!)) {
        nearestTime = adjustedTargetTime;
        nearestKey = key;
      }
    });

    if (nearestTime != null) {
      _nextTimeKey = nearestKey;
      _timeRemaining = nearestTime!.difference(now);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _timeRemaining -= Duration(seconds: 1);
          if (_timeRemaining <= Duration.zero) {
            AwesomeNotifications().createNotification(
                content: NotificationContent(
                    id: 1, channelKey: 'basic_channel', title: _nextTimeKey));
            _calculateNearestTime(); // Recalculate when the countdown ends
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = _timeRemaining.inHours;
    final minutes = _timeRemaining.inMinutes % 60;
    final seconds = _timeRemaining.inSeconds % 60;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_nextTimeKey != null)
              Text(
                "Next Prayer  $_nextTimeKey ${time[_nextTimeKey!]} ",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            Text(
              "${hours.toString().padLeft(2, '0')}:"
              "${minutes.toString().padLeft(2, '0')}:"
              "${seconds.toString().padLeft(2, '0')}",
              style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[850],
    );
  }
}
