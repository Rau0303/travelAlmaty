import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_almaty/widgets/buildEmailTextField_widget.dart';

import 'package:travel_almaty/widgets/buildTextField.dart';

import '../../services/auth_service.dart';
import '../homeScreen.dart';
import 'phoneAuthScreen.dart';


class signUpScreen extends StatefulWidget {
  const signUpScreen({Key? key}) : super(key: key);

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userPassController = TextEditingController();
  final TextEditingController _userPassConController = TextEditingController();
  bool isHiddenPassword = true;

  void createUser(){
    if(_userPassController.text==_userPassConController.text){
      final ap = Provider.of<authService>(context,listen: false);
      ap.createUserWithEmailAndPassword(context, _userNameController.text.trim(), _userPassController.text.trim());
    }
    else{
      print("zzz");
    }
  }
  void loginWithGoogle(){
    final ap = Provider.of<authService>(context,listen: false);
    ap.signInWithGoogleAccount(onSuccess: (){
      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const homeScreen()));
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const homeScreen()), (route) => false);
    });


  }
  void togglePass(){
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset("assets/signUp.png",
            scale: 0.5,),
            Text("Регистрация ",
            style: TextStyle(
              fontSize: 27.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            ),

            buildEmailTextField(userNameController: _userNameController, hintText: "Почта"),
            TextFormField(
              autocorrect: false,
              controller: _userPassController,
              obscureText: isHiddenPassword,
              validator: (value) => value != null && value.length < 6
                  ? 'Минимум 6 символов'
                  : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Введите пароль',
                suffix: InkWell(
                  onTap: togglePass,
                  child: Icon(
                    isHiddenPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            TextFormField(
              autocorrect: false,
              controller: _userPassController,
              obscureText: isHiddenPassword,
              validator: (value) => value != null && value.length < 6
                  ? 'Минимум 6 символов'
                  : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),

                hintText: 'Повторите пароль',
                suffix: InkWell(
                  onTap: togglePass,
                  child: Icon(
                    isHiddenPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.black,
                  ),
                ),
              ),
            ),


            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: ()=>createUser(),
                child: Text("Зарегистрироваться"),
              ),

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Уже есть аккаунт?"),
                TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text("Войти")),
              ],
            ),
            Text("Или"),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const phoneAuthScreen()));
                }, icon: Container(
                  height: 100,
                  child: Image.asset("icons/smartphone-call.png",
                    scale: 0.7,),
                )),
                IconButton(onPressed: (){
                  loginWithGoogle();
                }, icon: Container(
                  height: 50,
                  child: Image.asset("icons/google.png"),
                )),
              ],
            )




          ],

        ),
      ),
    );
  }
}
