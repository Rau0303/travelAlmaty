import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_almaty/screens/Authentication/SignIn.dart';
import 'package:travel_almaty/screens/Profile/UserPlacesScreen.dart';
import 'package:travel_almaty/screens/Profile/addHotelsScreen.dart';
import 'package:travel_almaty/screens/Profile/addRestaurantScreen.dart';
import 'package:travel_almaty/screens/Profile/addSightScreen.dart';
import 'package:travel_almaty/screens/Profile/profileSettingsScreen.dart';

import 'package:travel_almaty/services/SnackBar_service.dart';
import 'package:travel_almaty/services/profiel_service.dart';
import 'package:travel_almaty/services/userService.dart';



import '../../models/User.dart';
import '../../widgets/buildAccountOption.dart';
import '../../widgets/buildTextField.dart';
import '../../widgets/myAppBar.dart';
import '../../widgets/myBoxDecoration.dart';

class profileScreen extends StatefulWidget {
  const profileScreen({Key? key}) : super(key: key);

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  TextEditingController currentPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController newConPassController = TextEditingController();

  late String? photoUrl = "";
  late String? displayName = "";

  List<Users> myList = [];
  Future<void> changePass() async {
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text("Изменить пароль"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  buildTextField(Controller: currentPassController, hintText: "Введите старый пароль", obscureText: true),
                  const SizedBox(height: 10,),
                  buildTextField(Controller: newPassController, hintText: "Введите новый пароль", obscureText: true),
                  const SizedBox(height: 10,),
                  buildTextField(Controller: newConPassController, hintText: "Повторите новый пароль", obscureText: true),
                ],
              ),
            ),
            actions: [
              CupertinoDialogAction(
                child: TextButton(
                    onPressed: () async {
                      if (newPassController.text == newConPassController.text) {
                        final ap = Provider.of<profileService>(context, listen: false);
                        try {
                          await ap.changePassword(newPassController.text, currentPassController.text);
                          Navigator.of(context).popUntil((route) => false);
                        } catch (e) {
                          // Обработка ошибки
                          print("Ошибка изменения пароля: $e");
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ошибка изменения пароля: $e")));
                        }
                      } else {
                        // Показать сообщение об ошибке, если новый пароль не совпадает с подтверждением
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Новый пароль не совпадает с подтверждением")));
                      }
                    },
                    child: const Text("Сохранить")
                ),
              ),
            ],
          );
        }
    );
  }

  // Выход из аккаунта
  Future<void> exitAccount() async{
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text(
            "Вы действительно хотите выйти из аккаунта?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: null,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Отмена"),
            ),
            SizedBox(width: 150,),
            TextButton(
              onPressed: () {
                final ap = Provider.of<profileService>(context, listen: false);
                ap.signOut();
              },
              child: Text("Выйти"),
            ),
          ],
        );
      },
    );
  }

  // Удалить Пользователя
  Future<void> removeAccount() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Вы действительно хотите удалить аккаунт?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              "Вы больше не сможете пользоваться этим аккаунтом!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Нет"),
              ),
              SizedBox(width: 150,),
              TextButton(
                onPressed: () async {
                  try{
                    await Provider.of<UserService>(context, listen: false).deleteUser();
                    //Navigator.push(context, MaterialPageRoute(builder: (_)=>signIn()));

                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const signIn()), (route) => false);
                  }
                  catch(e){
                    SnackBarService.showSnackBar(context, 'Не удалось удалить пользователя!', true);
                  }
                },
                child: const Text("Да"),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();

    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;

    if (currentUser != null) {
      Provider.of<UserService>(context, listen: false).getUser().then((user) {
        setState(() {
          photoUrl = user?.photoUrl ?? "";
          displayName = user?.name ?? "";
        });
      });
    } else {
      photoUrl = null;
      displayName = "displayName";
    }
  }
  Future<void> loadPhotoUrl(String userId) async {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('users/$userId/photo.jpg');

    try {
      final url = await ref.getDownloadURL();
      setState(() {
        photoUrl = url;
      });
    } catch (e) {
      print('Ошибка загрузки фотографии: ');
    }
  }
/*
  @override
  void initState() {
    super.initState();

    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;

    if (currentUser != null) {
      Provider.of<UserService>(context, listen: false).getUser().then((user) {
        setState(() {
          displayName = user?.name ?? "";
          photoUrl = user?.photoUrl ?? "";
          print("photoUrl$photoUrl");
        });
      });
    } else {
      photoUrl = null;
      displayName = "displayName";
      print("photoUrl$photoUrl");
    }
  }*/


  @override
  Widget build(BuildContext context) {

    final ap = Provider.of<profileService>(context, listen: true);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: myAppBar(myTitleText: const Text("Профиль"),arrow_back: false,)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Flexible(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      //DisplayName and Photo
                      Container(
                        height: MediaQuery.of(context).size.height*0.30,
                        color: Colors.orange,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: displayName!.split(' ').map((word) {
                                    return Text(
                                      word,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                      ),
                                      textAlign: TextAlign.center,
                                    );
                                  }).toList(),
                                ),

                                InkWell(
                                  onTap: () {},
                                  child: photoUrl == null
                                      ? const CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 70,
                                  )
                                      : CircleAvatar(
                                    backgroundImage: NetworkImage(photoUrl!),
                                    radius: 70,
                                  ),
                                ),







                              ],
                            ),
                          ),
                        ),

                      ),
                      //Профиль
                      SingleChildScrollView(
                        child: Flexible(
                          child: Container(
                              width: MediaQuery.of(context).size.width*0.9,
                              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05,vertical: 0),
                              decoration: myBoxDecoration(),
                              child:Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Профиль",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Colors.black45
                                        ),),//TextButton or ListTile
                                      buildAccountOption(title: "Настройки профиля", onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const EditProfileScreen()));
                                      }),

                                      Divider(height:10 ,thickness: 2,),
                                      buildAccountOption(title: "Изменить пароль", onTap: (){
                                        changePass();
                                      }),
                                      Divider(height:10 ,thickness: 2,),
                                      buildAccountOption(title: "Выход", onTap: (){
                                        exitAccount();
                                      }),
                                      Divider(height:10 ,thickness: 2,),
                                      buildAccountOption(title: "Удалить аккаунт", onTap: (){
                                        removeAccount();
                                      }),
                                    ],
                                  ),
                                ),
                              )
                          ),
                        ),
                      ),

                      const SizedBox(height: 20,),


                      //Места Рестораны и отели
                     SingleChildScrollView(
                       child: Flexible(
                          child: Container(
                              width: MediaQuery.of(context).size.width*0.9,
                              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05,vertical: 0),
                              decoration: myBoxDecoration(),
                              child:Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Дополнительно",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Colors.black45
                                        ),),//TextButton or ListTile

                                      buildAccountOption(title: "Добавить места", onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> addSightScreen()));
                                      }),
                                      const Divider(height:10 ,thickness: 2,),
                                      buildAccountOption(title: "Добавить заведения", onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const addRestaurantScreen()));
                                      }),
                                      const Divider(height:10 ,thickness: 2,),
                                      buildAccountOption(title: "Добавить отели", onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const addHotelsScreen()));
                                      }),
                                      /*const Divider(height:10 ,thickness: 2,),
                                      buildAccountOption(title: "Мой места", onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> UserPlacesScreen(userId: FirebaseAuth.instance.currentUser!.uid)));
                                      }),*/





                                    ],
                                  ),
                                ),
                              )
                          ),
                        ),
                     ),

                      const SizedBox(height: 20,),

                    ],

                  ),
                ),
              ),
            ),
          ),




        ],
      ),
    );
  }
}










