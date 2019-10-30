import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class qnaPage extends StatefulWidget {
  @override
  _qnaPageState createState() => _qnaPageState();
}

class _qnaPageState extends State<qnaPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      appBar: buildAppBar(),

      backgroundColor: const Color(0xFFfff8fb),

      body: buildBody(),
    );

  }


  buildAppBar() {
    return GradientAppBar(
      centerTitle: true,
      title: Text('QnA', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      backgroundColorStart: const Color(0xFF7D6D9F),
      backgroundColorEnd: const Color(0xFF904666),
      actions: <Widget>[

      ],
    );
  }



  buildBody(){

    return Center(
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
      )
    );

  }
}
