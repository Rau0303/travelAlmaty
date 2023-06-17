import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:travel_almaty/screens/homeScreen.dart';

import '../../services/auth_service.dart';

class otpScreen extends StatefulWidget {
  final String verificationId;

  otpScreen({required this.verificationId});

  @override
  State<otpScreen> createState() => _otpScreenState();
}

class _otpScreenState extends State<otpScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController otpControler = TextEditingController();

    void otpCheck(){
      if(otpControler.text.length==0){

      }
      else{
        final ap = Provider.of<authService>(context,listen: false);

        ap.veridyOtp(context: context, userOtp: otpControler.text.trim(), verificationId: widget.verificationId, onSuccess: (){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const homeScreen()), (route) => false);
         // Navigator.push(context, MaterialPageRoute(builder: (context)=> homeScreen()));
        });

      }
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset("assets/otpSms.png",
              scale: 0.5,),
              Text("Введите смс код!",style: TextStyle(
                fontSize: 27.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),),

              Pinput(
                controller: otpControler,
                length: 6,
                showCursor: true,
                defaultPinTheme: PinTheme(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey,
                        )

                    ),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    )

                ),

              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: ()=>otpCheck(),
                  child: Text("Войти"),
                ),

              ),




            ],
          ),
        ),
      ),
    );
  }
}
