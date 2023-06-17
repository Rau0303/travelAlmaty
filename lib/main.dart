import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:travel_almaty/screens/Authentication/SignIn.dart';
import 'package:travel_almaty/screens/homeScreen.dart';
import 'package:travel_almaty/screens/Authentication/welcomeScreen.dart';
import 'package:travel_almaty/services/SnackBar_service.dart';
import 'package:travel_almaty/services/auth_service.dart';
import 'package:travel_almaty/services/favoriteService.dart';
import 'package:travel_almaty/services/hotelService.dart';
import 'package:travel_almaty/services/profiel_service.dart';
import 'package:travel_almaty/services/restaurantService.dart';
import 'package:travel_almaty/services/sightService.dart';
import 'package:travel_almaty/services/userService.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_)=>authService()),
      ChangeNotifierProvider(create: (_)=>profileService()),
      ChangeNotifierProvider(create: (_)=>UserService()),
      ChangeNotifierProvider(create: (_)=>SnackBarService()),
      ChangeNotifierProvider(create: (_)=>sightService()),
      ChangeNotifierProvider(create: (_)=>restaurantService()),
      ChangeNotifierProvider(create: (_)=>hotelService()),
      ChangeNotifierProvider(create: (_)=>FavoriteService()),
    ],
      child:  MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              // Пользователь авторизован
              return homeScreen();
            } else {
              // Пользователь не авторизован
              return welcomeScreen();
            }
          },
        ),
      ),
    );


  }
}

