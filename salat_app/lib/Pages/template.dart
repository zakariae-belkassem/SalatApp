import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:salat_app/Pages/main_page.dart';
import 'package:salat_app/Pages/map_mosques.dart';
import 'package:salat_app/Pages/qibla_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Template extends StatefulWidget {
  const Template({super.key});

  @override
  State<StatefulWidget> createState() => _TemplateState();
}

int myIndex = 0;
List<Widget> widgetList = const [MainPage(), QiblaPage(), MapMosques()];

// ignore: camel_case_types
class _TemplateState extends State<Template> {
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  void checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isConnected = false;
      });
    } else {
      setState(() {
        isConnected = true;
      });
    }

    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        isConnected = result != ConnectivityResult.none;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isConnected
          ? Center(
              child: widgetList[myIndex],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.wifi_off,
                    size: 50,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Internet is required to use this application.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: GNav(
        selectedIndex: myIndex,
        onTabChange: (index) {
          setState(() {
            myIndex = index;
          });
        },
        tabs: [
          GButton(
            icon: LineIcons.mosque,
            text: 'Prayers Time',
          ),
          GButton(
            icon: LineIcons.compass,
            text: 'Qibla',
          ),
          GButton(
            icon: LineIcons.map,
            text: 'Mosques',
          ),
        ],
      ),
    );
  }
}
