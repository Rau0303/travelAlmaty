import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';



class ChoosePlaceMap extends StatefulWidget {
  @override
  _ChoosePlaceMapState createState() => _ChoosePlaceMapState();
}

class _ChoosePlaceMapState extends State<ChoosePlaceMap> {
  GoogleMapController? _mapController;
  LatLng? _selectedLatLng;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onMapTap(LatLng? position) {

    setState(() {
      _selectedLatLng = position;
      print(_selectedLatLng);
    });
  }

  void _selectLocation() {
    Navigator.of(context).pop(_selectedLatLng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            onTap: _onMapTap,
            initialCameraPosition: CameraPosition(
              target: LatLng(43.2567, 76.9283),
              zoom: 10,
            ),
            markers: {
              if (_selectedLatLng != null)
                Marker(
                  markerId: const MarkerId('selectedLocation'),
                  position: _selectedLatLng!,
                ),
            },
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: _selectLocation,
              child: const Text('Сохранить'),
            ),
          ),

        ],
      ),
    );
  }
}
