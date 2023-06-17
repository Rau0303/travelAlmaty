import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class profileService extends ChangeNotifier{


// функция для обновления профиля пользователя




// функция для изменения пароля пользователя
  Future<void> changePassword(String newPassword, String currentPassword) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Проверяем, что текущий пароль пользователя совпадает с currentPassword
      final credential = EmailAuthProvider.credential(email: user.email!, password: currentPassword);
      await user.reauthenticateWithCredential(credential);
      // Если аутентификация прошла успешно, обновляем пароль пользователя на newPassword
      await user.updatePassword(newPassword);
    }
  }




// функция для выхода из аккаунта пользователя
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }


// функция для удаления аккаунта пользователя
  Future<void> deleteUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.delete();
    }
  }

  // Получить текущего пользователя
  FirebaseAuth auth = FirebaseAuth.instance;
  User? getCurrentUser() {
    User? user = auth.currentUser;
    return user;
  }

// Отменить доступ для пользователя, зарегистрированного через Google
  GoogleSignIn googleSignIn = GoogleSignIn();
  Future<void> revokeAccess() async {
    await googleSignIn.disconnect();
  }




}