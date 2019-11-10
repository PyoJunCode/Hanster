import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

      backgroundColor: const  Color(0xFFFFFFFF),

      body: buildBody(),
    );

  }





  buildBody(){

    return Center(
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.symmetric(vertical: 14.0),),
          Row(
            children: <Widget>[
              Container(

                  margin: EdgeInsets.only(left: 20.0),
//                  decoration: BoxDecoration(
//                      color: Color(0xFF333345),
//                      shape: BoxShape.circle,
//                      //borderRadius: BorderRadius.circular(8.0),
//                      boxShadow: <BoxShadow>[
//                        BoxShadow(
//                          color: Colors.black12,
//                          blurRadius: 10.0,
//                          offset: Offset(0.0, 10.0),
//                        )
//                      ]
//                  ),
                  child: IconButton(icon: Icon(Icons.arrow_back),
                    color: const Color(0xff333344),
                    onPressed: (){
                      Navigator.pop(context, MaterialPageRoute(
                          builder: (context) => qnaSubjectPage(widget.user)));
                    },)
              ),
              Padding(padding: EdgeInsets.only(left: 10.0),),
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
                stream: Firestore.instance.collection('QNA').where('class', isEqualTo: widget.subjectName).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return CustomScrollView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: false,
                      slivers: <Widget>[
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          sliver:  SliverList(
                            delegate:  SliverChildBuilderDelegate(
                                  (context, index) =>  postRow(snapshot.data.documents[index], widget.user),
                              childCount: snapshot.data.documents.length,
                            ),
                          ),
                        ),
                      ],
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


class Subject {

  final String className;

  const Subject({this.className});
}

class postRow extends StatelessWidget{

  //final String subject;
  final FirebaseUser user;
  final DocumentSnapshot postList;

  postRow(this.postList, this.user);

  @override
  Widget build(BuildContext context) {


    final baseTextStyle = const TextStyle(
        fontFamily: 'Poppins'
    );
    final regularTextStyle = baseTextStyle.copyWith(
        color: const Color(0xff747474),
        fontSize: 12.0,
        fontWeight: FontWeight.w400
    );
    final subHeaderTextStyle = regularTextStyle.copyWith(
        fontSize: 12.0,
        color: const Color(0xff4c4c4c),
    );
    final headerTextStyle = baseTextStyle.copyWith(
        color: const Color(0xff333344),
        fontSize: 15.0,
        fontWeight: FontWeight.w600
    );

    final subjectCardContent =  Container(
      margin:  EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 16.0),
      constraints:  BoxConstraints.expand(),
      child:  Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Container(height: 4.0),

              Flexible(
                child: Container(

                    width: 280,
                    child: Text(postList['title'], style: headerTextStyle)),
              ),
              //Padding(padding: EdgeInsets.only(top: 4.0),),

              //Container(height: 3.0),

              Text(postList['contents'], style: regularTextStyle),
              Text(postList['name'], style: subHeaderTextStyle),

              Container(
                  margin:  EdgeInsets.only(top: 10.0),
                  height: 2.0,
                  width: 345,
                  color:  Color(0xff535360)
              ),

            ],
          ),
          IconButton(icon: Icon(Icons.arrow_forward),
            color: Colors.white,
            onPressed: (){
//              Navigator.push(context, MaterialPageRoute(
//                  builder: (context) => qnaPage(user, subject)));
            },)
        ],
      ),
    );

    final subjectCard = GestureDetector(
        onTap: (){
//          Navigator.push(context, MaterialPageRoute(
//              builder: (context) => qnaPage(user, subject)));subject
        },
        child: Container(

          child: subjectCardContent,
          width: MediaQuery.of(context).size.width,
          height: 90.0,
          //margin: EdgeInsets.only(left: 46.0),
          decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8.0),
//              boxShadow: <BoxShadow>[
//                BoxShadow(
//                  color: Colors.black12,
//                  blurRadius: 10.0,
//                  offset: Offset(0.0, 10.0),
//                )
//              ]
          ),
        )
    );


    return  Container(
        width: MediaQuery.of(context).size.width,
        height: 90.0,
        margin: const EdgeInsets.symmetric(
          vertical: 3.0,
          horizontal: 0.0,
        ),
        child:  Stack(
          children: <Widget>[
            subjectCard,
            //subjectThumbnail,
          ],
        )
    );

  }
}

