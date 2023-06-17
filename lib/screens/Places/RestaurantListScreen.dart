import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_almaty/screens/Places/placeInformScreen.dart';

import '../../models/Restaurant.dart';

class RestaurantListScreen extends StatelessWidget {
  Future<List<Restaurant>> _fetchData() async {
    final snapshot =
    await FirebaseFirestore.instance.collection('restaurants').get();
    return snapshot.docs.map((doc) => Restaurant.fromDocument(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Рестораны'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Restaurant>>(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final restaurantList = snapshot.data!;
            print('Restaurant List: $restaurantList'); // Отладочная информация
            return ListView.builder(
              itemCount: restaurantList.length,
              itemBuilder: (context, index) {
                final restaurant = restaurantList[index];
                print('Restaurant: $restaurant'); // Отладочная информация
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      // Handle restaurant list item tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaceInformScreen(
                            placeId: restaurant.id,
                            collectionName: 'restaurants',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: restaurant.imageUrl.isNotEmpty ? NetworkImage(restaurant.imageUrl[0]) as ImageProvider : AssetImage(''),


                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          restaurant.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "Restaurant - №${index + 1} of ${restaurantList.length}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}'); // Отладочная информация
            return Text('Ошибка при загрузке данных');
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
