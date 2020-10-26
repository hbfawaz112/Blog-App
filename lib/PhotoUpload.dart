import 'package:blogappfirebase/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PhotoUpload extends StatefulWidget {
  @override
  _PhotoUploadState createState() => _PhotoUploadState();
}

class _PhotoUploadState extends State<PhotoUpload> {

final picker = ImagePicker();


  File sampleImge;
  final formKey = new GlobalKey<FormState>();
  String _myValue;
  String url;


    Future getImage() async {
      
      final File tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        sampleImge = tempImage;
      });
    }




    bool validateAndSave (){
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

    void uploadStatusImage() async {
      if(validateAndSave())
      {
          final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Post Images");
          var timeKey = new DateTime.now();

          final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImge);

          var ImageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

          url = ImageUrl.toString();

          print("Image url : "+ url);

          goToHomePage();

          saveToDatabase(url);
  }
      else{      }
    }

      void saveToDatabase(String url){
        var dbTimeKey = new DateTime.now();
        var formatDate = new DateFormat('MMM D, yyyy');
        var formatTime = new DateFormat('EEEE , hh:mm aaa ');


        String date = formatDate.format(dbTimeKey);
        String time = formatTime.format(dbTimeKey);
        
          DatabaseReference ref = FirebaseDatabase.instance.reference();

          var data =  {
            "image" : url , 
            "description" : _myValue ,
            "date": date, 
            "time" : time,
          };

          ref.child("Posts").push().set(data);

      }

      void goToHomePage(){
        Navigator.push(context,
            MaterialPageRoute(builder: (context){
              return new HomePage();
            })
         );
      }
  @override
  Widget build(BuildContext context) {
    return new Scaffold (

      appBar: AppBar(
        title:Text("Upload Iamge"),
        centerTitle:true
      ),

      body: new Center(
        child: sampleImge == null ? Text("Select an image ") : enableUpload(),
       ),

       floatingActionButton: new FloatingActionButton(
         onPressed: getImage , 
         tooltip: 'Add Image',
         child : new Icon(Icons.add_a_photo),
       
       ),
      
    );
  }

  Widget enableUpload(){
      return Container(
        child: new Form(
          key : formKey,
          child: Column(
            children: <Widget>[
              Image.file(sampleImge , height: 330.0, width: 660 , ) , 
              SizedBox(height:15.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText : 'Description'
                ),
                validator: (value) {
                  return value.isEmpty ? 'Blog Descirption is required!!!' : null;
                },
                onSaved: (value){
                  _myValue = value;
                }
              ) , 

               SizedBox(height:15.0),

               RaisedButton(
                 elevation: 10.0,
                 child: Text("Add a New Post"),
                 textColor: Colors.white,
                 color:Colors.red,
                 onPressed: uploadStatusImage, 

            
               )
            ],
          ),
          
    ),
      );
  }
}