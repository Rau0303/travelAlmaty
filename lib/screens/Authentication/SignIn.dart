import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_almaty/screens/Authentication/phoneAuthScreen.dart';
import 'package:travel_almaty/screens/homeScreen.dart';
import 'package:travel_almaty/widgets/buildTextField.dart';
import 'package:travel_almaty/services/auth_service.dart';

import '../../widgets/buildEmailTextField_widget.dart';
import 'SignUpScreen.dart';

class signIn extends StatefulWidget {
  const signIn({Key? key}) : super(key: key);

  @override
  State<signIn> createState() => _signInState();
}

class _signInState extends State<signIn> {
  bool isHiddenPassword = true;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userPassController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _userNameController;
    _userPassController;
  }


  @override
  void dispose() {
    super.dispose();
    _userNameController.dispose();
    _userPassController.dispose();
  }


  void login(){
    if(_userPassController.text.length<8){
      print("error");
    }
    else{
      final ap = Provider.of<authService>(context,listen: false);
      ap.signInWithEmailAndPassword(context, _userNameController.text.trim(), _userPassController.text.trim());

    }

  }

  void togglePass(){
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  void loginWithGoogle(){
    final ap = Provider.of<authService>(context,listen: false);
    ap.signInWithGoogleAccount(onSuccess: (){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const homeScreen()), (route) => false);
      //Navigator.push(context, MaterialPageRoute(builder: (context)=> homeScreen()));
    });


  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<authService>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset("assets/signIn.png",
            scale: 0.4,
            ),
            Text("Вход",
            style: TextStyle(
              fontSize: 27.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            ),


            buildEmailTextField(userNameController: _userNameController,hintText: "Почта"),

            //buildTextField(Controller: _userNameController,hintText: "Имя пользователя",obscureText: false,),

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

            //buildTextField(Controller: _userPassController, hintText: "Пароль", obscureText: true),


            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: ()=>login(),
                child: Text("Войти"),
              ),

            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const signUpScreen()));
                }, child: Text("Зарегистрироваться")),
                TextButton(onPressed: (){}, child: Text("Забыли пароль?")),
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
      ),
    );
  }
}











