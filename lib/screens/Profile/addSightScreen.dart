import 'dart:io';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:provider/provider.dart';
import 'package:travel_almaty/models/Sight.dart';
import 'package:travel_almaty/services/SnackBar_service.dart';
import 'package:travel_almaty/services/sightService.dart';


import 'choosePlaceMap_screen.dart';

class addSightScreen extends StatefulWidget {

  final LatLng? selectedLatLng;

  addSightScreen({this.selectedLatLng});

  @override
  State<addSightScreen> createState() => _addSightScreenState();
}

class _addSightScreenState extends State<addSightScreen> {
  //Контроллеры
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  List<ImageFile> images = <ImageFile>[];
  LatLng? _selectedLatLng;

  final controller = MultiImagePickerController(
    maxImages: 10, // максимальное количество изображений, которые можно выбрать
    withReadStream: true, // указываем, что нам нужны данные в виде байтов (stream)
    allowedImageTypes: ['png', 'jpg', 'jpeg'], // указываем разрешенные форматы изображений
  );

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

  void addSight() async {
    try {
      final ap = Provider.of<sightService>(context, listen: false);
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Загружаем фотографии в Storage и получаем ссылки на них
      final List<String> imageUrls = await Future.wait(
        images.map((file) async {
          final Reference ref = FirebaseStorage.instance
              .ref()
              .child('sights')
              .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
          final UploadTask uploadTask = ref.putFile(File(file.path!));
          final TaskSnapshot downloadUrl = await uploadTask;
          return (await downloadUrl.ref.getDownloadURL()).toString();
        }).toList(),
      );

      Sight sight = Sight(
        id: FirebaseFirestore.instance.collection('sights').doc().id,
        name: _nameController.text,
        description: _descriptionController.text,
        imageUrl: imageUrls,
        locationLat: _selectedLatLng!.latitude,
        locationLng: _selectedLatLng!.longitude,
        rating: 0.0,
        category: "",
        ownerId: uid,
        price: _priceController!.text
      );

      ap.addSight(sight);
      Navigator.pop(context);
    } catch (e) {
      SnackBarService.showSnackBar(
          context, "Не удалось загрузить достопримечательность!", true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<sightService>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить достопримечательность'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                  ],
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  label: const Text('Названия достопримечательности'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: _descriptionController,
                textInputAction: TextInputAction.done,
                maxLines: null,
                decoration: InputDecoration(
                  label: const Text('Описания достопримечательности'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  label: const Text('цена за поездку'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              SizedBox(height: 20,),
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
              SizedBox(height: 10,),
              ElevatedButton(onPressed: addSight, child: const Text("Сохранить!")),
            ],
          ),
        ),
      ),
    );
  }
}
