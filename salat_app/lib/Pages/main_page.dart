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

  _fetchData() async {
    String city = await _myService.getCurrentCity();
    String country = await _myService.getCurrentCountry();

    try {
      final my_obj = await _myService.getSalatTime(city, country);
      setState(() {
        my_obj.cityName = city;
        _salat = my_obj;
      });
    } catch (e) {
      //
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(_salat?.date ?? "loading"),
          Text('${_salat?.prayerTime.values}')
        ],
      ),
    );
  }
}
