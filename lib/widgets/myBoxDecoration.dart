import 'package:flutter/material.dart';

BoxDecoration myBoxDecoration() {
  return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 15,
          spreadRadius: 3,
        ),
      ]
  );
}