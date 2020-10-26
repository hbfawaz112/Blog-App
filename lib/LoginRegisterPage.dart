import 'dart:ffi';

import 'package:blogappfirebase/DialogBox.dart';
import 'package:flutter/material.dart';
import 'Authentication.dart';

class LoginRegisterPage extends StatefulWidget {



LoginRegisterPage({this.auth , this.onSignedIn});

  final AuthImplementation auth ;
  final VoidCallback onSignedIn;

  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();

  
}


enum FormType {
  login,
  register
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {



      DialogBox dialogBox = new DialogBox();

      final formKey = new GlobalKey<FormState>();

      FormType _formType = FormType.login;
      // ignore: unused_field
      String _email = "";
      // ignore: unused_field
      String _password = "";


      bool validateAndSave(){
          final form = formKey.currentState;

          if(form.validate())
            {
              form.save();
              return true;
            }
          else{
            return false;
          }
   }


  void validateAndSubmit() async {

            if(validateAndSave())
            {
              try{
                        if(_formType == FormType.login){
                            String userId = await widget.auth.SignIn(_email, _password);
                            print("login useID " + userId);
                        }
                        else{
                          String userId = await widget.auth.SignUp(_email, _password);
                          dialogBox.information(context, "Success" , "Account Created Succefuly :)");
                            print("Register useID" + userId);
                        }

                        widget.onSignedIn();
              }catch(e){
                dialogBox.information(context, "Error = " , e.toString());
                    print(e.toString());
              }
            }
  }

   void moveToRegister(){
      formKey.currentState.reset();

      setState(() {
        _formType= FormType.register;
      });
   }


      void moveToLogin(){
        formKey.currentState.reset();

        setState(() {
          _formType= FormType.login;
        });
      }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title:Text("Flutter Blog App"),
        centerTitle: true,
      ),
      body: Container(
        margin:EdgeInsets.all(9.0),
        child : new Form(
             key: formKey,
          child : Expanded(child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: createInputs() + createButtons()
            ),
          ),
        )
      ),
    );
  }

  List<Widget> createInputs()
  { return
    [
      SizedBox(height: 10.0),

      logo(),

      SizedBox(height: 5.0),

      new TextFormField(
        decoration: new InputDecoration(
          labelText: 'email',labelStyle: TextStyle(fontSize: 20.0)
        ),
        validator: (value)
        {
          return value.isEmpty ? 'Email is required' : null;
        },
        onSaved:  (value){
          return _email = value;
        }
      ),

      SizedBox(height: 10.0),

      new TextFormField(
        decoration: new InputDecoration(
          labelText: 'Password',labelStyle: TextStyle(fontSize: 20.0)
        ),

          validator: (value)
          {
            return value.isEmpty ? 'Password is required' : null;
          },
          onSaved:  (value){
            return _password = value;
          } ,
        obscureText: true,
      ),

      SizedBox(height: 20.0,),

    ];
  }


  List <Widget> createButtons(){
    if(_formType == FormType.login)
      {
        return [
          new RaisedButton(
            child: new Text("Login", style: TextStyle(fontSize: 20.0 )),
            textColor: Colors.white,
            color: Colors.red,
            onPressed: validateAndSubmit,
          ),

          new FlatButton(
            child: new Text("Not have an Account ? Create an account", style: TextStyle(fontSize: 14.0 )),
            textColor: Colors.red,
            onPressed: moveToRegister,
          ),
        ];
      }
    else{
      return [
        new RaisedButton(
          child: new Text("Create Account", style: TextStyle(fontSize: 20.0 )),
          textColor: Colors.white,
          color: Colors.red,
          onPressed: validateAndSubmit,
        ),

        new FlatButton(
          child: new Text("Already have an account ? Go and login !", style: TextStyle(fontSize: 18.0 )),
          textColor: Colors.red,
          onPressed: moveToLogin,
        ),
      ];
    }
  }


  Widget logo(){
    return new  Hero(

      tag: "hero",
      child:  CircleAvatar(

          backgroundColor: Colors.transparent,

          radius:110.0,

          child:Image.asset('Images/logo.png' , width: 200,height: 200,),
      ),
    );
  }

}

