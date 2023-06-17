import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:provider/provider.dart';
import 'package:travel_almaty/screens/Authentication/SignIn.dart';
import 'package:travel_almaty/screens/Authentication/otpScreen.dart';
import 'package:travel_almaty/services/SnackBar_service.dart';
import 'package:travel_almaty/widgets/buildTextField.dart';

import '../../services/auth_service.dart';



class phoneAuthScreen extends StatefulWidget {
  const phoneAuthScreen({Key? key}) : super(key: key);

  @override
  State<phoneAuthScreen> createState() => _phoneAuthScreenState();
}

class _phoneAuthScreenState extends State<phoneAuthScreen> {
  final TextEditingController _userPhoneController = TextEditingController();

  void phoneAuth(){
    if(_userPhoneController.text.length<10){
      SnackBarService.showSnackBar(context, 'введите корректный номер телефона', true);
    }
    else{
      final ap = Provider.of<authService>(context,listen: false);
      String phoneNumber = country.phoneCode + _userPhoneController.text.trim();
      ap.signInWithPhoneNumber(context, phoneNumber);
    }
  }

  Country country = Country(
      phoneCode: "+7",
      countryCode: "KZ",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "Kazakhstan",
      example: "Kazakhstan",
      displayName: "Kazakhstan",
      displayNameNoCountryCode: "KZ",
      e164Key: "");

  void selectCountry(){
    showCountryPicker(
        context: context,
        onSelect: (value){
          setState(() {
            value = country;
          });
        });
  }


  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    _userPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset("assets/phoneSign.png",
              //scale: 0.8,
              ),
              Text("Вход по номеру телефона",style: TextStyle(
                fontSize: 27.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),),

              //buildTextField(Controller: _userPhoneController, hintText: "Введите номер телефона", obscureText: false),
              TextFormField(
                controller: _userPhoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    hintText: "Введите номер телефона",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Container(
                      margin: EdgeInsets.all(13.0),
                      child: InkWell(
                        onTap: (){
                          showCountryPicker(
                              context: context,
                              onSelect: (value){
                                setState(() {
                                  country= value;
                                });
                              });
                        },
                        child: Text(
                          "${country.flagEmoji} ${country.phoneCode}",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),

                    )

                ),


              ),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: ()=>phoneAuth(),
                  child: Text("Отправить код"),
                ),

              ),


              Text("Или"),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const signIn()));
                  }, icon: SizedBox(child: Container(
                    height: 50,
                    child: Image.asset("icons/mail.png",
                    scale: 0.3,
                    ),
                  ))),
                  IconButton(onPressed: (){

                  }, icon:Container(
                    child: Image.asset("icons/google.png"),
                  ) ),
                ],
              )
            ],
          ),
        ),
      ),

    );
  }
}
