import 'package:cloud_firestore/cloud_firestore.dart';

class Users{
  String id;
  String name;
  String email;
  String phoneNumber;
  int age;
  String photoUrl;


  Users({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber = "",
    this.age = 0,
    required this.photoUrl,
  });


  factory Users.fromDocument(DocumentSnapshot doc) {
    return Users(
        id: doc.id,
        name: doc['name'],
        email: doc['email'],
        phoneNumber: doc['phoneNumber'],
        age: doc['age'],
        photoUrl: doc['photoUrl']);
  }



  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber':phoneNumber,
      'age':age,
      'photoUrl':photoUrl
    };
  }


}
