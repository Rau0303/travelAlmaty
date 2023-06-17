import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

import '../models/Sight.dart';

class sightService extends ChangeNotifier{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
//добавить фотографию
  Future<String> uploadImage(ImageFile file) async {
    try {
      final Reference storageRef =
      FirebaseStorage.instance.ref().child('sights').child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      final UploadTask uploadTask = storageRef.putFile(file as File);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw e;
    }
  }


  // Добавление достопремичательностей
  Future<void> addSight(Sight sight) async {
    try {
      // Загружаем фотографии в Storage и получаем ссылки на них


      // Добавляем достопримечательность в Firestore
      final docRef = FirebaseFirestore.instance.collection('sights').doc();
      final docId = docRef.id;

      await docRef.set({
        'id': docId,
        'name': sight.name,
        'description': sight.description,
        'imageUrl': sight.imageUrl,
        'locationLat':sight.locationLat,
        'locationLng':sight.locationLng,
        'rating': sight.rating,
        'category': sight.category,
        'ownerId': sight.ownerId,
        'price':sight.price,
      });
    } catch (e) {
      throw e;
    }
  }


  // обнавление достопремичательностей
  Future<void> updateSight(Sight sight) async {
    final docRef = FirebaseFirestore.instance.collection('sights').doc(sight.id);

    try {
      await docRef.update({
        'name': sight.name,
        'description': sight.description,
        'imageUrl': sight.imageUrl,
        'locationLat':sight.locationLat,
        'locationLng':sight.locationLng,
        'rating': sight.rating,
        'category': sight.category,
        'ownerId': sight.ownerId, // Обновляем id владельца
      });
    } catch (e) {
      throw e;
    }
  }

  //удаление достапремичательностей
  Future<void> deleteSight(String sightId, String ownerId, List<String> imageUrls) async {
    final docRef = FirebaseFirestore.instance.collection('sights').doc(sightId);

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