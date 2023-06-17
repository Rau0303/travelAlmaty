import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/Favorites.dart';

class FavoriteService extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addFavorite(Favorites favorite) {
    CollectionReference favorites = firestore.collection('favorites');
    DocumentReference favoriteRef = favorites.doc(favorite.id);
    return favoriteRef.set(favorite.toMap()).then((_) {
      notifyListeners(); // Добавьте оповещение после добавления избранного
    });
  }

  Future<void> updateFavorite(Favorites favorite) {
    CollectionReference favorites = firestore.collection('favorites');
    DocumentReference favoriteRef = favorites.doc(favorite.id);
    return favoriteRef.update(favorite.toMap()).then((_) {
      notifyListeners(); // Добавьте оповещение после обновления избранного
    });
  }
}
