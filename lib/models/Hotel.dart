import 'package:cloud_firestore/cloud_firestore.dart';

class Hotel {
  String id;
  String name;
  String description;
  List<dynamic> imageUrl;
  double locationLat;
  double locationLng;
  double rating;
  String priceRange;

  Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.locationLat,
    required this.locationLng,
    required this.rating,
    required this.priceRange,
  });

  factory Hotel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    final id = doc.id;
    final name = data != null ? data['name'] ?? '' : '';
    final description = data != null ? data['description'] ?? '' : '';
    final imageUrl = data != null ? List<dynamic>.from(data['imageUrl'] ?? []) : [];
    final locationLat = data != null ? data['locationLat'] ?? 0.0 : 0.0;
    final locationLng = data != null ? data['locationLng'] ?? 0.0 : 0.0;
    final rating = data != null ? data['rating'] ?? 0.0 : 0.0;
    final priceRange = data != null ? data['price_range'] ?? '' : '';

    return Hotel(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      locationLat: locationLat,
      locationLng: locationLng,
      rating: rating,
      priceRange: priceRange,
    );
  }


  Map<String,dynamic> toMap(){
    return{
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'locationLat': locationLat,
      'locationLng': locationLng,
      'rating': rating,
      'priceRange': priceRange
    };

    }
  }
