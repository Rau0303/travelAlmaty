
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_almaty/screens/Places/placeInformScreen.dart';

import '../../models/Sight.dart';

class SightListScreen extends StatelessWidget {

  Future<List<Sight>> _fetchData() async {
    final snapshot =
    await FirebaseFirestore.instance.collection('sights').get();
    return snapshot.docs.map((doc) => Sight.fromDocument(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Места'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Sight>>(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final sightList = snapshot.data!;
            return ListView.builder(
              itemCount: sightList.length,
              itemBuilder: (context, index) {
                final sight = sightList[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaceInformScreen(
                            placeId: sight.id,
                            collectionName: 'sights',
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
                          image: NetworkImage(sight.imageUrl[0]),
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          sight.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "Sight - №${index + 1} of ${sightList.length}",
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
            return Text('Error retrieving data');
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