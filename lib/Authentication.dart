import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

abstract class AuthImplementation 
{
   Future<String> SignIn(String email , String password );
   // ignore: non_constant_identifier_names
   Future<String> SignUp(String email , String password ); 
   Future<String> getCurrentUser();
   Future<void> signOut();
}

class Auth implements AuthImplementation {

    //Firebase.initializeApp();

   final FirebaseAuth _firebaseAuth  = FirebaseAuth.instance;

  Future<String> SignIn(String email , String password ) async {
    await Firebase.initializeApp();
    // ignore: deprecated_member_use
    User user = (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;

    return user.uid;
    
  }

  Future<String> SignUp(String email , String password ) async {
    await Firebase.initializeApp();
    // ignore: deprecated_member_use
    User user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;

    return user.uid;
    
  }

  Future<String> getCurrentUser() async {
    await Firebase.initializeApp();
    // ignore: deprecated_member_use
    User user =  await _firebaseAuth.currentUser;
  }

  Future<void> signOut() async {
    await Firebase.initializeApp();
    _firebaseAuth.signOut();
  }
}