import 'package:flutter/material.dart';

class buildAccountOption extends StatelessWidget {
  buildAccountOption({
    //required this.myIcon,
    required this.title,
    required this.onTap,
  });

  String title;
  Function () onTap;
  //Icon myIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //myIcon,
            Text(title,style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black
            ),),
            Icon(Icons.arrow_forward_ios,color: Colors.grey,)
          ],
        ),
      ),
    );
  }
}