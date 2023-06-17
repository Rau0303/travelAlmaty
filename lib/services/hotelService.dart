import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../models/Hotel.dart';

class hotelService extends ChangeNotifier{
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> uploadImage(File file) async {
    try {
      final Reference storageRef =
      FirebaseStorage.instance.ref().child('hotels').child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      final UploadTask uploadTask = storageRef.putFile(file);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw e;
    }
  }

  Future<void> addHotel(Hotel hotel) async {
    try{

      final docRef = FirebaseFirestore.instance.collection('hotels').doc();
      final docId = docRef.id;

      await docRef.set({
        'id': docId,
        'name': hotel.name,
        'description': hotel.description,
        'imageUrl': hotel.imageUrl,
        'locationLat': hotel.locationLat,
        'locationLng': hotel.locationLng,
        'rating': hotel.rating,
        'priceRange': hotel.priceRange,
      });
    }
    catch (e){
      throw e;
    }


  }

  Future<void> updateHotel(Hotel hotel) {
    CollectionReference hotels = firestore.collection('hotels');
    DocumentReference hotelRef = hotels.doc(hotel.id);
    return hotelRef.update(hotel.toMap());
  }
}