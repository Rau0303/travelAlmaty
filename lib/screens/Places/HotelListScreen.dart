import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_almaty/screens/Places/placeInformScreen.dart';

import '../../models/Hotel.dart';

class HotelListScreen extends StatelessWidget {
  Future<List<Hotel>> _fetchData() async {
    final snapshot = await FirebaseFirestore.instance.collection('hotels').get();
    return snapshot.docs.map((doc) => Hotel.fromDocument(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Отели'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Hotel>>(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Отображаем индикатор загрузки, пока данные загружаются
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Обрабатываем ошибку при загрузке данных
            return Text('Ошибка при загрузке данных: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Если данных нет или список отелей пуст, отображаем сообщение об отсутствии данных
            return Text('Нет доступных данных об отелях');
          } else {
            // Отображаем список отелей
            final hotelList = snapshot.data!;
            return ListView.builder(
              itemCount: hotelList.length,
              itemBuilder: (context, index) {
                final hotel = hotelList[index];
                print("hotesl: $hotel");
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaceInformScreen(
                            placeId: hotel.id,
                            collectionName: 'hotels',
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
                          image: NetworkImage(hotel.imageUrl[0]),
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          hotel.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "Отель - №${index + 1} из ${hotelList.length}",
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
          }
        },
      ),
    );
  }
}
