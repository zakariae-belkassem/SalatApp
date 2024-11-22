import 'package:flutter/material.dart';
import 'package:salat_app/Pages/countdown_to_nearest_time.dart';
import 'package:salat_app/Pages/main_page.dart';
import 'package:salat_app/Pages/qibla_page.dart';

class Template extends StatefulWidget {
  const Template({super.key});
  @override
  State<StatefulWidget> createState() => _templateState();
}

int myIndex = 0;
List<Widget> widgetList = const [
  MainPage(),
  QiblaPage(),
  CountdownToNearestTime({
    "Fajr": "06:30",
    "Sunrise": "08:02",
    "Dhuhr": "13:17",
    "Asr": "16:03",
    "Sunset": "18:22",
    "Maghrib": "18:27",
    "Isha": "19:44",
    "Imsak": "06:20",
    "Midnight": "01:12",
    "Firstthird": "22:56",
    "Lastthird": "03:29"
  })
];

// ignore: camel_case_types
class _templateState extends State<Template> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetList[myIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          //backgroundColor: Colors.black,
          fixedColor: const Color.fromARGB(255, 6, 184, 255),
          onTap: (value) => {
                setState(() {
                  myIndex = value;
                })
              },
          currentIndex: myIndex,
          items: [
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/mosque.png",
                  width: 24,
                  height: 24,
                ),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/qibla-compass2.png",
                  width: 24,
                  height: 24,
                ),
                label: "Qibla"),
            BottomNavigationBarItem(icon: Icon(Icons.adb), label: "smthng2"),
          ]),
    );
  }
}
