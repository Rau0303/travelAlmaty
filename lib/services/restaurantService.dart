import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/Restaurant.dart';

class restaurantService extends ChangeNotifier{
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> uploadImage(File file) async {
    try {
      final Reference storageRef =
      FirebaseStorage.instance.ref().child('restaurants').child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      final UploadTask uploadTask = storageRef.putFile(file);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw e;
    }
  }

  Future<void> addRestaurant(Restaurant restaurant) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('restaurants').doc();
      final docId = docRef.id;

      // Преобразование imageUrl в List<String>
      final List<String> imageUrls = restaurant.imageUrl.map((url) => url.toString()).toList();

      await docRef.set({
        'id': docId,
        'name': restaurant.name,
        'description': restaurant.description,
        'imageUrl': imageUrls, // Используйте преобразованный List<String>
        'locationLat': restaurant.locationLat,
        'locationLng': restaurant.locationLng,
        'rating': restaurant.rating,
        'cuisine': restaurant.cuisine,
        'ownerId': restaurant.ownerId,
        'price':restaurant.price,
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateRestaurant(Restaurant restaurant) {
    CollectionReference restaurants = firestore.collection('restaurants');
    DocumentReference restaurantRef = restaurants.doc(restaurant.id);
    return restaurantRef.update(restaurant.toMap());
  }


  //удаление достапремичательностей
  Future<void> deleteRestaurant(String restaurantId, String ownerId, List<String> imageUrls) async {
    final docRef = FirebaseFirestore.instance.collection('restaurants').doc(restaurantId);

    final doc = await docRef.get();
    if (doc.exists && doc.data()?['ownerId'] == ownerId) {
      try {
        // удаление документа из Firestore
        await docRef.delete();

        // удаление фотографий из Storage
        final storageRef = FirebaseStorage.instance.ref();
        for (final imageUrl in imageUrls) {
          await storageRef.child(imageUrl).delete();
        }
      } catch (e) {
        throw e;
      }
    } else {
      throw Exception('У вас нет прав на удаление этой достопримечательности');
    }
  }
}