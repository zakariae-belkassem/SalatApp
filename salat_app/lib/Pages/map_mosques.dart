import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:salat_app/services/Mosque_service.dart';

class MapMosques extends StatefulWidget {
  const MapMosques({super.key});
  @override
  State<StatefulWidget> createState() => _MapMosques();
}

class _MapMosques extends State<MapMosques> {
  Myservice? service = Myservice();
  double? latitude;
  double? longitude;
  List<Marker> mosqueMarkers = [];

  void fetchUserLocation() async {
    latitude = await service!.getLat();
    longitude = await service!.getLong();
    if (latitude == null || longitude == null) {
      Future.delayed(Duration(seconds: 15), () {
        fetchUserLocation();
      });
    } else {
      fetchMosques();
    }
    setState(() {});
  }

  void fetchMosques() async {
    final mosques = await service!.getMosquesNearby(latitude!, longitude!);
    if (mosques != null) {
      mosqueMarkers = mosques.map((mosque) {
        return Marker(
            point: LatLng(latitude ?? 34.023609, longitude ?? -6.837820),
            child: Icon(Icons.location_pin));
      }).toList();
      setState(() {});
    }
  }

  @override
  void initState() {
    fetchUserLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mosques Nearby")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(latitude ?? 34.023609, longitude ?? -6.837820),
          initialZoom: 11,
        ),
        children: [
          openStreetMapTileLayer,
          MarkerLayer(markers: mosqueMarkers),
        ],
      ),
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
      userAgentPackageName: 'dev.flutter.example',
    );
