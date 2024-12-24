import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:salat_app/Pages/main_page.dart';
import 'package:salat_app/Pages/map_mosques.dart';
import 'package:salat_app/Pages/qibla_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class Template extends StatefulWidget {
  const Template({super.key});

  @override
  State<StatefulWidget> createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
  int myIndex = 0;
  bool isConnected = true;

  List<Widget> widgetList = const [MainPage(), QiblaPage(), MapMosques()];

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  void checkConnectivity() async {
    final connectivityResults = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResults.firstOrNull);

    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((results) {
      _updateConnectionStatus(results.firstOrNull);
    });
  }

  void _updateConnectionStatus(ConnectivityResult? result) async {
    if (result != null && result != ConnectivityResult.none) {
      // Check for real internet access
      bool hasInternet = await _isInternetAvailable();
      setState(() {
        isConnected = hasInternet;
      });
    } else {
      setState(() {
        isConnected = false;
      });
    }
  }

  /// Perform a simple HTTP check to ensure real internet access
  Future<bool> _isInternetAvailable() async {
    try {
      final response = await http.get(Uri.parse('https://google.com'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850], // Dark grey background
      body: isConnected
          ? widgetList[myIndex]
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Internet Connection',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please check your network.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Container(
        color: Colors.grey[900], // Slightly darker grey for the nav bar
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: GNav(
              selectedIndex: myIndex,
              gap: 8,
              color: Colors.grey[400], // Inactive tab color
              activeColor: Colors.white, // Active tab text/icon color
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 600),
              tabBackgroundColor: const Color.fromARGB(
                  255, 71, 71, 71), // Active tab background (Green)
              tabs: const [
                GButton(
                  icon: LineIcons.mosque,
                  text: 'Prayers',
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
              onTabChange: (index) {
                setState(() {
                  myIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
