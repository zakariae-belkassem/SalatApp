import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});
  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  bool _hasPermission = false;
  @override
  void initState() {
    super.initState();
    _fetchPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        if (_hasPermission) {
          return _buildCompass();
        } else {
          return _builsPermissionSheet();
        }
      }),
    );
  }

  void _fetchPermission() {
    Permission.locationWhenInUse.status.then((value) => {
          if (mounted)
            {
              setState(() {
                _hasPermission = (value == PermissionStatus.granted);
              })
            }
        });
  }

  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
      stream: Stream.periodic(
        Duration(milliseconds: 200),
        (_) => FlutterCompass.events!.first,
      ).asyncExpand(
          (eventFuture) => eventFuture.asStream()), // Resolve future events
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error"),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        double? direction = snapshot.data?.heading;
        if (direction == null) {
          return Center(
            child: Text("Not supported by your device"),
          );
        }
        return Center(
          child: Container(
            padding: EdgeInsets.all(25),
            child: Transform.rotate(
              angle: direction * (pi / 180) * -1,
              child: Image.asset("assets/icons/qibla-compass.png"),
            ),
          ),
        );
      },
    );
  }

  Widget _builsPermissionSheet() {
    return Center(
      child: ElevatedButton(
          child: Text('Need Location'),
          onPressed: () => {
                Permission.locationWhenInUse
                    .request()
                    .then((value) => {_fetchPermission()})
              }),
    );
  }
}
