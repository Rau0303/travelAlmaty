import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_almaty/models/User.dart';
import 'package:travel_almaty/services/SnackBar_service.dart';
import 'dart:io';
import '../../services/image_service.dart';
import '../../services/userService.dart';
import '../../widgets/buildTextField.dart';
import '../../widgets/myAppBar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userPhoneController = TextEditingController();
  final TextEditingController _userAgeController = TextEditingController();
  File? image;

  // select image
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _userEmailController.dispose();
    _userPhoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;

    if (currentUser != null) {
      String? email = currentUser.email;
      String? phone = currentUser.phoneNumber;
      String? name = currentUser.displayName;
      String? photoURL = currentUser.photoURL;

      if (email != null) {
        _userEmailController.text = email;
      }

      if (phone != null) {
        _userPhoneController.text = phone;
      }
      if(name!= null){
        _fullNameController.text = name;
      }



    }
  }

  void updateData() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      Users user = Users(
        id: uid,
        name: _fullNameController.text,
        email: _userEmailController.text,
        phoneNumber: _userPhoneController.text,
        age: int.tryParse(_userAgeController.text) ?? 0,
        photoUrl: null ?? "",
      );

      await Provider.of<UserService>(context, listen: false)
          .updateUser(user, photo: image);
      Navigator.pop(context);
    } catch (error) {
      SnackBarService.showSnackBar(
          context, 'Неудалось сохранить данные попробуйте позднее!', true);
    }
  }


  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<UserService>(context, listen: true);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: myAppBar(myTitleText: const Text("Профиль"), arrow_back: true),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            child: Center(
              child: Column(
                children: [
                  InkWell(
                    onTap: () => selectImage(),
                    child: image == null
                        ? const CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 70,
                    )
                        : CircleAvatar(
                      backgroundImage: FileImage(image!),
                      radius: 70,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  buildTextField(
                    Controller: _fullNameController,
                    hintText: "name",
                    obscureText: false,
                  ),
                  SizedBox(height: 20),
                  buildTextField(
                    Controller: _userEmailController,
                    hintText: "email",
                    obscureText: false,
                  ),
                  SizedBox(height: 20),
                  buildTextField(
                    Controller: _userPhoneController,
                    hintText: "phone number",
                    obscureText: false,
                  ),
                  SizedBox(height: 20),
                  buildTextField(
                    Controller: _userAgeController,
                    hintText: "your age",
                    obscureText: false,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => updateData(),
                    child: Text('Сохранить'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}
