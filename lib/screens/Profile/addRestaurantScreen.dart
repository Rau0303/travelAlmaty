import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:provider/provider.dart';
import 'package:travel_almaty/models/Restaurant.dart';

import 'package:travel_almaty/services/SnackBar_service.dart';
import 'package:travel_almaty/services/restaurantService.dart';

import 'choosePlaceMap_screen.dart';

class addRestaurantScreen extends StatefulWidget {
  const addRestaurantScreen({Key? key}) : super(key: key);

  @override
  State<addRestaurantScreen> createState() => _addRestaurantScreenState();
}

class _addRestaurantScreenState extends State<addRestaurantScreen> {
  final TextEditingController _resNameController = TextEditingController();
  final TextEditingController _resDescriptionController = TextEditingController();
  final TextEditingController _resLocationLatContoller  = TextEditingController();
  final TextEditingController _resLocationLongController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final controller = MultiImagePickerController(
    maxImages: 10,
    withReadStream: true,
    allowedImageTypes: ['png', 'jpg', 'jpeg'],
  );

  List<ImageFile>  images = [];
  LatLng? _selectedLatLng;

  void _showChoosePlaceMap() async {
    final result = await Navigator.of(context).push<LatLng?>(
      MaterialPageRoute(
        builder: (context) => ChoosePlaceMap(),
      ),
    );

    print("result is $result");

    if (result != null) {
      setState(() {
        _selectedLatLng = result;
      });
      print("select is $_selectedLatLng");
    }
  }

  Future<void> addRestaurant() async {

    try{
      final ap = Provider.of<restaurantService>(context,listen: false);

      String user = FirebaseAuth.instance.currentUser!.uid;

      // Загружаем фотографии в Storage и получаем ссылки на них
      final List<String> imageUrls = await Future.wait(
        images.map((file) async {
          final Reference ref = FirebaseStorage.instance.ref().child('restaurants').child('${DateTime.now().millisecondsSinceEpoch}.jpg');
          final UploadTask uploadTask = ref.putFile(File(file.path!));
          final TaskSnapshot downloadUrl = await uploadTask;
          return (await downloadUrl.ref.getDownloadURL()).toString();
        }).toList(),
      );


      Restaurant restaurant = Restaurant(
          id: FirebaseFirestore.instance.collection('restaurants').doc().id,
          name: _resNameController.text,
          description: _resDescriptionController.text,
          imageUrl:imageUrls,
          locationLat: _selectedLatLng!.latitude,
          locationLng: _selectedLatLng!.longitude,
          rating: 0.0,
          cuisine: "",
          ownerId: user,
          price: _priceController!.text,
      );

      ap.addRestaurant(restaurant);
    }
    catch(e){
      SnackBarService.showSnackBar(context, "Не удалось загрузить данные! ", true);
    }
    Navigator.pop(context);


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Добавить ресторан"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  MultiImagePickerView(
                    onChange: (Iterable<ImageFile> list) {
                      setState(() {
                        images.addAll(list);
                      });
                    },
                    controller: controller,
                  ),

                  const SizedBox(height: 20,),

                  TextField(
                    controller: _resNameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      label: const Text('Названия достопримечательности'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextField(
                    controller: _resDescriptionController,
                    textInputAction: TextInputAction.done,
                    maxLines: null,
                    decoration: InputDecoration(
                      label: const Text('описания достопримечательности'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  TextField(
                    controller: _priceController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      label: const Text('Средняя цена'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  if (_selectedLatLng == null)
                    ElevatedButton(
                      onPressed: _showChoosePlaceMap,
                      child: const Text('Выбрать место на карте'),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: _showChoosePlaceMap,
                          child: const Text('Выбрать другое место на карте'),
                        ),
                        const SizedBox(height: 16.0),
                        Text('Широта: ${_selectedLatLng!.latitude}'),

                        const SizedBox(height: 8.0),
                        Text('Долгота: ${_selectedLatLng!.longitude}'),
                      ],
                    ),
                  const SizedBox(height: 20,),
                  ElevatedButton(onPressed: ()=>addRestaurant(), child: Text("Сохранить!"))



                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
