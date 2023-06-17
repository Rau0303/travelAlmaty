import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_almaty/services/SnackBar_service.dart';

Future<File?> pickImage(BuildContext context)async{
  File? image;
  try{
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedImage != null){
      image =  File(pickedImage.path);
    }
  }catch(e){
    SnackBarService.showSnackBar(context, e.toString(), true);
  }
  return image;
}