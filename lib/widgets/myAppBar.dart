import 'package:flutter/material.dart';

class myAppBar extends StatefulWidget {
  myAppBar({
    required this.myTitleText,
    required this.arrow_back,
  });

  Text myTitleText;
  bool arrow_back;

  @override
  State<myAppBar> createState() => _myAppBarState();
}

class _myAppBarState extends State<myAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppBar(
        backgroundColor: Colors.black,
        title: widget.myTitleText,
        automaticallyImplyLeading: widget.arrow_back,
        centerTitle: true,
      ),
    );
  }
}