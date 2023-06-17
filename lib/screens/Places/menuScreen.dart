import 'package:flutter/material.dart';
import 'HotelListScreen.dart';
import 'RestaurantListScreen.dart';
import 'SightListScreen.dart';

class MenuScreen extends StatefulWidget {
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Меню'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(

        padding: const EdgeInsets.all(10.0),
        child: ListView(

          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SightListScreen(),
                  ),
                );
              },
              child: Container(
                height: 200,
                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                      image:AssetImage("myPlacesImages/bao_1.jpg"),
                  scale: 0.1,
                  )
                ),
                child: ListTile(
                  title: const Text(
                    "Места",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ),
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RestaurantListScreen(),
                  ),
                );
              },
              child: Container(
                  height: 200,
                  decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                          image:AssetImage("myPlacesImages/rest.jpg") )
                  ),
               child: const ListTile(
                  title: Text(
                    "Рестораны",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ),
              ),
            ),
            SizedBox(height: 20,),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HotelListScreen(),
                  ),
                );
              },
              child: Container(
                  height: 200,
                  decoration: BoxDecoration(


                      borderRadius: BorderRadius.circular(20),

                      image: const DecorationImage(
                        fit: BoxFit.cover,
                          image:AssetImage("myPlacesImages/rixos.jpg") )
                  ),
                child: const ListTile(
                  title: Text(
                    "Отели",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
