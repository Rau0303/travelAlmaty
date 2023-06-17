import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class buildEmailTextField extends StatelessWidget {
    buildEmailTextField({
    required this.userNameController,
    required this.hintText,
  });

  final TextEditingController userNameController;
  String hintText;



  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      onSaved: (value){
        FocusScope.of(context).nextFocus();
      },
      keyboardType: TextInputType.emailAddress,

      autocorrect: false,
      controller: userNameController,
      validator: (email) =>
      email != null && !EmailValidator.validate(email)
          ? 'Введите правильный Email'
          : null,
      decoration:  InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
      ),
    );
  }
}