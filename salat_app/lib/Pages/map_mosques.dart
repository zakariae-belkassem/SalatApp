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
    latitude = await service!.getLat();
    longitude = await service!.getLong();
    if (latitude == null || longitude == null) {
      Future.delayed(Duration(seconds: 15), () {
        myfunction();
      });
    }
  }

  @override
  void initState() {
    myfunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print(latitude);
    return FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(latitude ?? 34.023609, longitude ?? -6.837820),
          initialZoom: 11,
        ),
        children: [
          openStreetMapTileLayer,
          MarkerLayer(markers: [
            Marker(
                point: LatLng(latitude ?? 34.023609, longitude ?? -6.837820),
                child: Icon(Icons.location_pin))
          ])
        ]);
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
      userAgentPackageName: 'dev.flutter.example',
    );
