import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:provider/provider.dart';
import 'package:travel_almaty/models/Hotel.dart';
import 'package:travel_almaty/models/Restaurant.dart';

import 'package:travel_almaty/services/SnackBar_service.dart';
import 'package:travel_almaty/services/hotelService.dart';

import 'choosePlaceMap_screen.dart';

class addHotelsScreen extends StatefulWidget {
  const addHotelsScreen({Key? key}) : super(key: key);

  @override
  State<addHotelsScreen> createState() => _addHotelsScreenState();
}

class _addHotelsScreenState extends State<addHotelsScreen> {
  final TextEditingController _hotelNameController = TextEditingController();
  final TextEditingController _hotelDescriptionController = TextEditingController();
  final TextEditingController _hotelLocationLatControler = TextEditingController();
  final TextEditingController _hotelLocationLongControler = TextEditingController();
  final TextEditingController _priceRangeController = TextEditingController();

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


  Future<void> addHotel() async {
    try{
      final ap = Provider.of<hotelService>(context,listen: false);
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String hotelId = FirebaseFirestore.instance.collection('hotels').doc().id;

      // Загружаем фотографии в Storage и получаем ссылки на них
      final List<String> imageUrls = await Future.wait(
        images.map((file) async {
          final Reference ref = FirebaseStorage.instance.ref().child('hotels').child('${DateTime.now().millisecondsSinceEpoch}.jpg');
          final UploadTask uploadTask = ref.putFile(File(file.path!));
          final TaskSnapshot downloadUrl = await uploadTask;
          return (await downloadUrl.ref.getDownloadURL()).toString();
        }).toList(),
      );


      Hotel hotel = Hotel(
          id: hotelId,
          name: _hotelNameController.text,
          description: _hotelDescriptionController.text,
          imageUrl: imageUrls,
          locationLat: _selectedLatLng!.latitude,
          locationLng: _selectedLatLng!.longitude,
          rating: 0.0,
          priceRange: _priceRangeController!.text);

      ap.addHotel(hotel);
    }
    catch(e){
      SnackBarService.showSnackBar(context, "Не удалось загрузить данные. Попробуйте позднее!", true);
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
                      controller: _hotelNameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        label: const Text('Названия отеля'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    TextField(
                      controller: _hotelDescriptionController,
                      textInputAction: TextInputAction.done,
                      maxLines: null,
                      decoration: InputDecoration(
                        label: const Text('описания отеля'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _priceRangeController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        label: const Text('Средняя цена за номер'),
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
                    ElevatedButton(onPressed: () =>addHotel(),
                        child: Text("Сохранить!"))



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
