import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:latlong2/latlong.dart';
import 'package:salat_app/services/Myservice.dart';

class MapMosques extends StatefulWidget {
  const MapMosques({super.key});
  @override
  State<StatefulWidget> createState() => _MapMosques();
}

class _MapMosques extends State<MapMosques> {
  Myservice? service = Myservice();
  double? latitude;
  double? longitude;
  void myfunction() async {
    this.latitude = await service!.getLat();
    this.longitude = await service!.getLong();
  }

  @override
  Widget build(BuildContext context) {
    myfunction();
    return FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(latitude!, longitude!),
        ),
        children: []);
  }
}
