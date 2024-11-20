import 'package:flutter/material.dart';

class MyNavBar extends StatelessWidget {
  const MyNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(destinations: [
        Container(
          color: Colors.amber,
        ),
        Container(
          color: Colors.white,
        ),
        Container(
          color: Colors.blue,
        ),
        Container(
          color: Colors.orange,
        ),
      ]),
    );
  }
}
