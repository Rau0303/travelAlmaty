import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant{
  String id;
  String name;
  String description;
  List<dynamic> imageUrl;
  double locationLat;
  double locationLng;
  double rating;
  String cuisine;
  String ownerId;
  String price;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.locationLat,
    required this.locationLng,
    required this.rating,
    required this.cuisine,
    required this.ownerId,
    required this.price
  });

  factory Restaurant.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    final id = doc.id;
    final name = data != null ? data['name'] ?? '' : '';
    final description = data != null ? data['description'] ?? '' : '';
    final imageUrl = data != null ? List<String>.from(data['imageUrl'] ?? []) : [];
    final locationLat = data != null ? data['locationLat'] ?? 0.0 : 0.0;
    final locationLng = data != null ? data['locationLng'] ?? 0.0 : 0.0;
    final rating = data != null ? data['rating'] ?? 0.0 : 0.0;
    final cuisine = data != null ? data['cuisine'] ?? '' : '';
    final ownerId = data != null ? data['ownerId'] ?? '' : '';
    final price = data != null ? data['price'] ?? '' : '';

    return Restaurant(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      locationLat: locationLat,
      locationLng: locationLng,
      rating: rating,
      cuisine: cuisine,
      ownerId: ownerId,
      price: price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'locationLat': locationLat,
      'locationLng': locationLng,
      'rating': rating,
      'cuisine': cuisine,
      'ownerId':ownerId,
      'price': price,
    };
  }
}