import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceInformScreen extends StatelessWidget {
  final String placeId;
  final String collectionName;

  const PlaceInformScreen({Key? key, required this.placeId, required this.collectionName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection(collectionName).doc(placeId).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return Text('ошибочка');
        }

        final placeData = snapshot.data!.data() as Map<String, dynamic>?; // Explicitly cast to Map<String, dynamic>
        if (placeData == null) {
          return Text('Список пуст');
        }

        final String placeName = placeData['name'] as String;
        final String placeDescription = placeData['description'] as String;
        final List<String> imageUrls = List<String>.from(placeData['imageUrl'] ?? []);
        final double locationLat = placeData['locationLat'] as double;
        final double locationLng = placeData['locationLng'] as double;
        final String? placePrice = placeData['price'] as String?;

        void openGoogleMaps() async {
          final url = 'https://www.google.com/maps/search/?api=1&query=$locationLat,$locationLng';
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not open Google Maps';
          }
        }

        return Scaffold(
          
          appBar: AppBar(
            title: Text(placeName),
            centerTitle: true,
            backgroundColor: Colors.black,
          ),
          body: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      // Add images in PageView
                      SizedBox(
                        height: 200,
                        child: PageView.builder(
                          itemCount: imageUrls.length,
                          itemBuilder: (BuildContext context, int imageIndex) {
                            return Image.network(
                              imageUrls[imageIndex],
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          placeDescription,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Средняя цена за поездку $placePrice",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                // Add a map using Google Maps Flutter plugin
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.3,
                      width: MediaQuery.of(context).size.width,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(locationLat, locationLng),
                          zoom: 15.0,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId(placeId),
                            position: LatLng(locationLat, locationLng),
                          ),
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: openGoogleMaps,
                      child: Text('Маршрут'),
                    ),
                  ),
                ),
              ],
            ),

        );
      },
    );
  }
}
