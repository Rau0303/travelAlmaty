import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:travel_almaty/services/SnackBar_service.dart';

import '../screens/homeScreen.dart';
import '../screens/Authentication/otpScreen.dart';

class authService extends ChangeNotifier{
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading  => _isLoading;

  String? _uid ;
  String get uid => _uid!;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;


  //вход через номер телефона
  void signInWithPhoneNumber(BuildContext context,String phoneNumber) async{
    try{
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async{
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (FirebaseAuthException error){
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context)=> otpScreen(verificationId: verificationId,),
              ),
            );
          },
          codeAutoRetrievalTimeout: (verificationId){}
      );
    }
    on FirebaseAuthException catch(e){
      SnackBarService.showSnackBar(context, e.message.toString(),true);
    }
  }
  // верификация по номеру телефона
  void veridyOtp({
    required BuildContext context,
    required String userOtp,
    required String verificationId,
    required Function onSuccess
  })async{
    _isLoading =true;
    notifyListeners();
    try{
      PhoneAuthCredential creds = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: userOtp);
      User? user = (await _firebaseAuth.signInWithCredential(creds)).user!;
      if(user != null){
        _uid = user.uid;
        onSuccess();
      }
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch(e){
        SnackBarService.showSnackBar(context, e.message.toString(),true);
      _isLoading = false;
      notifyListeners();
    }
  }


  // вход через почту и пароль
  void signInWithEmailAndPassword(BuildContext context, String email, String password)async{
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context)=> homeScreen(),
        ),
      );
    }
    on FirebaseAuthException catch(e){
      if(e.code =='user-not-found'){
        SnackBarService.showSnackBar(context, 'Неправильный email или пароль. Повторите попытку', true);
        return;
      }
      else if(e.code == 'wrong-password'){
        SnackBarService.showSnackBar(context, 'Неправильный email или пароль. Повторите попытку', true);
        return;
      }
      else{
        SnackBarService.showSnackBar(
          context,
          'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.',
          true,
        );
      }

    }

  }


  // регистрация через почту и пароль
  void createUserWithEmailAndPassword(BuildContext context,String email,String password) async{
    try{
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    }
    on FirebaseAuthException catch(e){
      if(e.code == 'email-alreay-in-use'){
        SnackBarService.showSnackBar(context, 'Такой Email уже используется, повторите попытку с использованием другого Email', true);
        return;
      }
      else{
        SnackBarService.showSnackBar(context, 'Что - то пошло не так!', true);
        print("wrong pass");
      }
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context)=> homeScreen(),
      ),
    );
  }

// Вход через google аккаунт

void signInWithGoogleAccount({
  required Function onSuccess
})async{
    try{
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
     // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>homeScreen()), (route) => false);
    }
    on FirebaseAuthException catch(e){
      //SnackBarService.showSnackBar(context, 'Что - то пошло не так!', true);
      return;
    }

}


}