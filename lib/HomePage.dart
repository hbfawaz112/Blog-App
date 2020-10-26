import 'package:blogappfirebase/PhotoUpload.dart';
import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'Posts.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.onSignedOut});

  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Posts> postList = [];

  @override
  void initState() {
    super.initState();

    DatabaseReference postRef =
        FirebaseDatabase.instance.reference().child("Posts");

    postRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      postList.clear();

      for (var i_keys in KEYS) {
        Posts post = new Posts(
          DATA[i_keys]['image'],
          DATA[i_keys]['description'],
          DATA[i_keys]['date'],
          DATA[i_keys]['time'],
        );
        postList.add(post);
      }
      setState(() {
        print(postList.length);
        // postList = postList;
      });
    });
  }

  void _logouUser() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e.toString());
    }
  }
  /*
   
            Text('Home Page', style: TextStyle(fontWeight: FontWeight.w900)),
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

          title:Text('Home Page', style: TextStyle(fontWeight: FontWeight.w900)),
          centerTitle: true,
          actions: <Widget>[
              IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => {_logouUser},
            ),
            Text(
              "logout                 ",
              style: TextStyle(fontSize: 13.0),
            ),
          ],
          
          ),


      body: new Container(
        child: postList.length == 0
            ? new Center(child: Text("No post yet"))
            : new ListView.builder(
                itemCount: postList.length,
                itemBuilder: (_, index) {
                  return PostUI(
                    postList[index].image,
                    postList[index].description,
                    postList[index].date,
                    postList[index].time,
                  );
                }),
      ),
    

    bottomNavigationBar:
    new BottomAppBar(
      color: Colors.red,
      child: new Container(
        child: new Row(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          //mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // new IconButton(icon: Icon(Icons.arrow_back_ios), iconSize: 50,color: Colors.white,onPressed: () => {_logouUser()}),
            //SizedBox(height: 30),
            new IconButton(
                icon: Icon(Icons.add_a_photo),
                iconSize: 50,
                color: Colors.white,
                onPressed: () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return new PhotoUpload();
                      }))
                    }),
          ],
        ),
      ),
    )
    );
  }

  Widget PostUI(String image, String description, String date, String time) {
    return new Card(
      elevation: 11.0,
      margin: EdgeInsets.all(15.0),
      child: new Container(
          padding: EdgeInsets.all(14.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                    date,
                    style: Theme.of(context).textTheme.subtitle,
                    textAlign: TextAlign.center,
                  ),
                  new Text(
                    time,
                    style: Theme.of(context).textTheme.subtitle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: 10.0),

              new Image.network(image, fit: BoxFit.cover , width: 700, height:200,),
              
              SizedBox(height: 10.0),
              new Text(
                description,
                style: Theme.of(context).textTheme.subhead,
                textAlign: TextAlign.center,
              ),
            ],
          )),
    );
  }
}
