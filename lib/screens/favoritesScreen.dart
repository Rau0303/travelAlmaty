import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_almaty/models/Favorites.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('favorites')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Favorites> favoritesList = [];
          snapshot.data!.docs.forEach((doc) {
            favoritesList.add(Favorites.fromDocument(doc));
          });

          return ListView.separated(
            itemCount: favoritesList.length,
            separatorBuilder: (BuildContext context, int index) =>
                Divider(),
            itemBuilder: (BuildContext context, int index) {
              Favorites favorites = favoritesList[index];

              return ListTile(
                title: Text('Избранное ${favorites.id}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Места: ${favorites.sight!.name}'),
                    Text('Рестораны: ${favorites.restaurant!.name}'),
                    Text('Отели: ${favorites.hotel!.name}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
