import 'package:flutter/material.dart';
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
          return _builCompass();
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

  Widget _builCompass() {
    return Scaffold();
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
