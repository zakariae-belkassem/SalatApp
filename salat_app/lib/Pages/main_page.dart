import 'package:flutter/material.dart';
import 'package:salat_app/models/salat_model.dart';
import 'package:salat_app/services/Myservice.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_salat?.date ?? "loading"),
            Text('${_salat?.prayerTime}')
          ],
        ),
      ),
    );
  }
}
