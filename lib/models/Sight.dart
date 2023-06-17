  import 'dart:io';

  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:google_maps_flutter/google_maps_flutter.dart';


  class Sight{
    String id;
    String name;
    String description;
    List<String> imageUrl;
    double locationLat;
    double locationLng;
    double rating;
    String category;
    String ownerId;
    String price;

    Sight({
      required this.id,
      required this.name,
      required this.description,
      required this.imageUrl,
      required this.locationLat,
      required this.locationLng,
      required this.rating,
      required this.category,
      required this.ownerId,
      required this.price
    });

    factory Sight.fromDocument(DocumentSnapshot doc) {
      return Sight(
        id: doc.id,
        name: doc['name'],
        description: doc['description'],
        imageUrl: List<String>.from(doc['imageUrl'] ?? []),
        locationLat: doc['locationLat'],
        locationLng: doc['locationLng'],
        rating: doc['rating'],
        category: doc['category'],
        ownerId: doc['ownerId'],
        price: doc['price'],
      );
    }

    Map<String, dynamic> toMap() {
      return {
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'locationLat': locationLat,
        'locationLng': locationLng,
        'rating': rating,
        'category': category,
        'ownerId': ownerId,
        'price':price,
      };
    }
  }
