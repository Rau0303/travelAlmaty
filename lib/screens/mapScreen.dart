import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import '../models/Favorites.dart';
import '../models/Sight.dart';
import '../services/favoriteService.dart';
import 'Places/placeInformScreen.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  List<dynamic> _sights = [];
  Set<Marker> _markers = {};
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _loadSights();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentPosition = position;
    });
  }


  Future<void> _loadSights() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('sights').get();
    setState(() {
      _sights = querySnapshot.docs.map((doc) => doc.data()).toList();
      _markers = _sights.map((sight) => Marker(
        markerId: MarkerId(sight['id']),
        position: LatLng(sight['locationLat'], sight['locationLng']),
        onTap: () {
          _showSightModalBottomSheet(context,sight);
        },
      )).toSet();
    });
  }


  void _showSightModalBottomSheet(BuildContext context, dynamic sight) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Пользователь не вошел в систему, покажите сообщение или перенаправьте его на страницу входа
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (sight['imageUrl'] != null && sight['imageUrl'].isNotEmpty)
                Image.network(
                  sight['imageUrl'][0], // Первый URL-адрес из списка
                  height: 200,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 16),
              Text(
                sight['name'],
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                sight['description'],
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text('Добавить в избранное'),
                onPressed: () async {
                  Favorites favorite = Favorites(
                    id: user.uid,
                    userId: user.uid,
                    sight: Sight.fromDocument(sight),
                  );
                  await FavoriteService().addFavorite(favorite);
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                child: Text('Перейти на страницу информации о месте'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PlaceInformScreen(
                        placeId: sight['id'], // Передайте ID места в PlaceInformScreen
                        collectionName: 'sights', // Передайте имя коллекции в PlaceInformScreen
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: (controller) {
          _mapController = controller;
        },
        compassEnabled: true,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            _currentPosition?.latitude ?? 43.2567,
            _currentPosition?.longitude ?? 76.9283,
          ),
          zoom: 15,
        ),
        markers: _markers,
      ),
    );
  }
}
