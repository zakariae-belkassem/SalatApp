import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:salat_app/services/mosque_service.dart';

class MapMosques extends StatefulWidget {
  const MapMosques({super.key});

  @override
  State<StatefulWidget> createState() => _MapMosquesState();
}

class _MapMosquesState extends State<MapMosques> {
  MosqueService service = MosqueService();

  double? latitude;
  double? longitude;
  List<Marker> mosqueMarkers = [];
  Marker? userMarker; // User's location marker
  bool isLoading = true;

  // Fetch user location
  void fetchUserLocation() async {
    latitude = await service.getLat();
    longitude = await service.getLong();

    if (latitude == null || longitude == null) {
      Future.delayed(const Duration(seconds: 15), fetchUserLocation);
    } else {
      setState(() {
        userMarker = Marker(
          point: LatLng(latitude!, longitude!),
          width: 40,
          height: 40,
          child: const Icon(
            Icons.my_location,
            color: Colors.blue, // Blue color for user marker
            size: 30,
          ),
        );
      });
      fetchMosques();
    }
  }

  // Fetch mosques from the service
  void fetchMosques() async {
    final mosques = await service.getMosquesNearby(latitude!, longitude!);
    if (mosques != null) {
      setState(() {
        mosqueMarkers = mosques.map((mosque) {
          return Marker(
            point: LatLng(mosque['lat'], mosque['lon']),
            width: 50,
            height: 50,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_pin,
                  color: Colors.green, // Green color for mosque markers
                  size: 30,
                ),
                Text(
                  mosque['name'], // Mosque name
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green, // Text color matches marker
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }).toList();
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Mosques"),
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: Colors.grey[900],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading
          : FlutterMap(
              options: MapOptions(
                initialCenter:
                    LatLng(latitude ?? 34.023609, longitude ?? -6.837820),
                initialZoom: 15,
              ),
              children: [
                openStreetMapTileLayer,
                MarkerLayer(
                  markers: [
                    if (userMarker != null) userMarker!, // Add user marker
                    ...mosqueMarkers, // Add mosque markers
                  ],
                ),
              ],
            ),
    );
  }
}

// Tile layer for OpenStreetMap
TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
      userAgentPackageName: 'dev.flutter.example',
    );
