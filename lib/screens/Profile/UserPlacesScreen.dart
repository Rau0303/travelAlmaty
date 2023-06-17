import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../../models/Hotel.dart';
import '../../models/Restaurant.dart';
import '../../models/Sight.dart';

class UserPlacesScreen extends StatelessWidget {
  final String userId;

  UserPlacesScreen({required this.userId});

  Stream<List<dynamic>> _fetchData() {
    final hotelsStream = FirebaseFirestore.instance
        .collection('hotels')
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Hotel.fromDocument(doc)).toList());

    final restaurantsStream = FirebaseFirestore.instance
        .collection('restaurants')
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Restaurant.fromDocument(doc)).toList());

    final sightStream = FirebaseFirestore.instance
        .collection('sights')
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Sight.fromDocument(doc)).toList());

    return CombineLatestStream.list<dynamic>([
      hotelsStream,
      restaurantsStream,
      sightStream,
    ]).asBroadcastStream();
  }


  Widget _buildHotelItem(Hotel hotel) {
    return ListTile(
      title: Text(hotel.name),
      subtitle: Text(hotel.description),
      // Add any additional widgets or customizations for the hotel item
    );
  }

  Widget _buildRestaurantItem(Restaurant restaurant) {
    return ListTile(
      title: Text(restaurant.name),
      subtitle: Text(restaurant.cuisine),
      // Add any additional widgets or customizations for the restaurant item
    );
  }

  Widget _buildSightItem(Sight sight) {
    return ListTile(
      title: Text(sight.name),
      // Add any additional widgets or customizations for the sight item
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мои места'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<List<dynamic>>(
        stream: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<dynamic> placesList = snapshot.data!;
            final List<Hotel> hotels = placesList[0];
            final List<Restaurant> restaurants = placesList[1];
            final List<Sight> sights = placesList[2];

            return ListView.builder(
              itemCount: hotels.length + restaurants.length + sights.length,
              itemBuilder: (context, index) {
                if (index < hotels.length) {
                  final hotel = hotels[index];
                  return _buildHotelItem(hotel);
                } else if (index < hotels.length + restaurants.length) {
                  final restaurant =
                  restaurants[index - hotels.length];
                  return _buildRestaurantItem(restaurant);
                } else {
                  final sight =
                  sights[index - hotels.length - restaurants.length];
                  return _buildSightItem(sight);
                }
              },
            );
          } else if (snapshot.hasError) {
            return Text('Ошибка при получении данных');
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

}
