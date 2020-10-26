import 'package:flutter/material.dart';

import 'Authentication.dart';

import 'LoginRegisterPage.dart';

import 'HomePage.dart';

class MappingPage extends StatefulWidget {

  final AuthImplementation auth;

  MappingPage({ this.auth }) ;

  @override
  _MappingPageState createState() => _MappingPageState();
}


enum AuthStatus {
  notSigndIn,
  signedIn,
}

class _MappingPageState extends State<MappingPage> {

  AuthStatus authStatus = AuthStatus.notSigndIn;

  void initState(){
    super.initState();

    widget.auth.getCurrentUser().then((firebaseUserId) => {
      setState( (){
        authStatus = firebaseUserId == null ? AuthStatus.notSigndIn : AuthStatus.signedIn;
      }),
    });
  }
 
   void _signedIn()
   {
     setState(() {
        authStatus = AuthStatus.signedIn;
     });
   }

   void _signedOut()
   {
     setState(() {
        authStatus = AuthStatus.notSigndIn;
     });
   }

  @override
  Widget build(BuildContext context) {
    switch (authStatus)
    {
        case AuthStatus.notSigndIn :
         return new LoginRegisterPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );
        
      case AuthStatus.signedIn:
        return new HomePage(
          auth: widget.auth,
          onSignedOut: _signedOut,
        );
    }
  }
}