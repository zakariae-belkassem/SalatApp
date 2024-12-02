import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:salat_app/Pages/main_page.dart';
import 'package:salat_app/Pages/map_mosques.dart';
import 'package:salat_app/Pages/qibla_page.dart';

class Template extends StatefulWidget {
  const Template({super.key});
  @override
  State<StatefulWidget> createState() => _templateState();
}

int myIndex = 0;
List<Widget> widgetList = const [MainPage(), QiblaPage(), MapMosques()];

// ignore: camel_case_types
class _templateState extends State<Template> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetList[myIndex],
      ),
      bottomNavigationBar: GNav(
          selectedIndex: myIndex,
          onTabChange: (index) {
            setState(() {
              myIndex = index;
            });
          }, // navigation bar padding
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
          ]),
    );
  }
}
