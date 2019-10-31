import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:hanster_app/qnaSubject.dart';

class qnaPage extends StatefulWidget {

  final FirebaseUser user;
  String subjectName;

  qnaPage(this.user, this.subjectName);

  @override
  _qnaPageState createState() => _qnaPageState();
}

class _qnaPageState extends State<qnaPage> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      backgroundColor: const  Color(0xFF97AFB9),

      body: buildBody(),
    );

  }





  buildBody(){

    return Center(
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(14.0),),
          Row(
            children: <Widget>[
              Container(

                  margin: EdgeInsets.only(left: 25.0),
                  decoration: BoxDecoration(
                      color: Color(0xFF333345),
                      shape: BoxShape.circle,
                      //borderRadius: BorderRadius.circular(8.0),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                          offset: Offset(0.0, 10.0),
                        )
                      ]
                  ),
                  child: IconButton(icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: (){
                      Navigator.pop(context, MaterialPageRoute(
                          builder: (context) => qnaSubjectPage(widget.user)));
                    },)
              ),
              Padding(padding: EdgeInsets.only(left: 25.0),),
              Container(
                width: 250,
                child: Text(widget.subjectName, style: TextStyle(color: Color(0xFF333345),
                    fontSize: 23.0,
                    fontWeight: FontWeight.w600)),
              )
            ],
          ),
          Expanded(
            child: Container(
              child: StreamBuilder(
                stream: Firestore.instance.collection('QNA').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) {

                        return Card(
                          child : ListTile(
                            title: Text(snapshot.data.documents[index]['title']),
                          ),
                        );
                      } ,
                      itemCount: snapshot.data.documents.length,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      )
    );

  }
}
