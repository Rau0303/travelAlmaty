import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/User.dart';



class UserService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Users?> getUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await _firestore.collection('users').doc(user.uid).get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;

        final displayName = data['name'];
        final photoUrl = data['photoUrl'];

        Users userObj = Users(
          id: user.uid,
          name: displayName,
          email: user.email!,
          phoneNumber: data['phoneNumber'],
          age: data['age'],
          photoUrl: photoUrl,
        );
        return userObj;
      }
    }
    return null;
  }

  Future<void> addUser(Users user) async {
    final users = _firestore.collection('users');
    final userRef = users.doc(user.id);
    await userRef.set(user.toMap());
  }

  Future<void> updateUser(Users user, {File? photo}) async {
    try {
      final userRef = _firestore.collection('users').doc(user.id);

      // Check if the user exists in Firestore
      final doc = await userRef.get();

      if (doc.exists) {
        // If the user exists, update the data
        if (photo != null) {
          final photoUrl = await _uploadPhoto(photo, user.id);
          user.photoUrl = photoUrl;
        }
        await userRef.update(user.toMap());
      } else {
        // If the user doesn't exist, create a new record
        await addUser(user);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User is not logged in');
      }

      // Delete the user
      await _firestore.collection('users').doc(user.uid).delete();

      // Get all user's favorites
      final favoritesSnapshot = await _firestore
          .collection('favorites')
          .where('user_id', isEqualTo: user.uid)
          .get();

      // Delete all user's favorites
      for (final favoriteDoc in favoritesSnapshot.docs) {
        await favoriteDoc.reference.delete();
      }

      // Delete the user's photo if it exists
      if (user.photoURL != null) {
        await _storage.refFromURL(user.photoURL!).delete();
      }

      // Delete the user account
      await user.delete();
    } catch (error) {
      throw error;
    }
  }

  Future<String> _uploadPhoto(File photo, String userId) async {
    try {
      final storageRef = _storage.ref().child('users/$userId/photo.jpg');
      final uploadTask = storageRef.putFile(photo);
      final snapshot = await uploadTask.whenComplete(() {});
      return snapshot.ref.getDownloadURL();
    } catch (error) {
      throw error;
    }
  }

  User? get currentUser => FirebaseAuth.instance.currentUser;
}
