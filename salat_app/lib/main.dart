import 'package:flutter/material.dart';
import 'package:salat_app/Pages/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
   
   @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const MaterialApp(
      debugShowCheckedModeBanner : false,
      home: MainPage(),
      

   );
  }
}

