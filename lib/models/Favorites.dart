import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_almaty/models/Hotel.dart';
import 'package:travel_almaty/models/Restaurant.dart';
import 'package:travel_almaty/models/Sight.dart';
import 'package:travel_almaty/models/User.dart';

class Favorites {
  String id;
  String userId;
  Sight? sight;
  Restaurant? restaurant;
  Hotel? hotel;

  Favorites({
    required this.id,
    required this.userId,
    this.sight,
    this.restaurant,
    this.hotel,
  });

  factory Favorites.fromDocument(DocumentSnapshot doc) {
    return Favorites(
      id: doc.id,
      userId: doc['userId'],
      sight: Sight.fromDocument(doc['sight']),
      restaurant: Restaurant.fromDocument(doc['restaurant']),
      hotel: Hotel.fromDocument(doc['hotel']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'sight': sight?.toMap(),
      'restaurant': restaurant?.toMap(),
      'hotel': hotel?.toMap(),
    };
  }
}