import 'package:blogappfirebase/HomePage.dart';
import 'package:blogappfirebase/LoginRegisterPage.dart';
import 'package:blogappfirebase/Mapping.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Authentication.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   runApp(BlogApp());
} 

class BlogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    title: "Blog App Firebase",
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MappingPage(auth: Auth() , ),
    );
  }
}
