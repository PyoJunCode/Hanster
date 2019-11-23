import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hanster_app/qnaRead.dart';
import 'package:hanster_app/qnaSubject.dart';
import 'package:hanster_app/qnaWrite.dart';



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

      appBar: buildAppBar(),
    );
  }

  buildAppBar() {
    return AppBar(
      centerTitle: true,
      title:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Image.asset('assets/images/qnaLogo.png' , height: 30,),
//          Icon(Icons.question_answer,color: Colors.yellow,size: 30,),
//          Padding(padding: EdgeInsets.only(left: 10),),
//          Text('QnA', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
//          title: Text("Study Group"),
      leading: IconButton(
          color: Colors.white,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          }),
      actions: <Widget>[
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.menu),
          onPressed: ()=>{
          },
        ),
      ],
    );
  }





  buildBody(){

    return Center(
      child: Column(
        children: <Widget>[
          //Padding(padding: EdgeInsets.symmetric(vertical: 14.0),),

           Container(
              //width:  MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
//                  Container(
//
//                      margin: EdgeInsets.only(left: 20.0),
//
//                  ),
                  //Padding(padding: EdgeInsets.only(left: 10.0),),

                     Expanded(
                       child: Container(

                         height: 80,
                         decoration: BoxDecoration(

                             color:  Color(0xFFFFFFFF)   ,
                             shape: BoxShape.rectangle,

                             borderRadius: BorderRadius.circular(8.0),
                             boxShadow: <BoxShadow>[
                               BoxShadow(
                                 color: Colors.black12,
                                 blurRadius: 10.0,
                                 offset: Offset(0.0, 10.0),
                               )
                             ]
                         ),
                        //width: MediaQuery.of(context).size.width,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Container(
                                  
                                  child: Text(widget.subjectName , overflow: TextOverflow.ellipsis ,style:TextStyle(color: Color(0xFF86a2ea) ,
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.w600,),
                                  ),
                                ),
                              ),
                            Container(
                              width: 60,
                              height: 30,

                              child: RaisedButton(
                                child: Text('글쓰기', style: TextStyle(color:  Colors.white , fontSize: 10, fontWeight: FontWeight.w800)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),

                                ),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => writeQnaPage(widget.user, widget.subjectName)));
                                },
                                color: Color(0xFFF9BE06),
                              ),
                            ),

                            ],
                          ),
                        ),
                    ),
                     ),

                ],
              ),
            ),

          Expanded(
            child: Container(
              child: StreamBuilder(
                stream: Firestore.instance.collection('QNA').where('class', isEqualTo: widget.subjectName).orderBy('time', descending: true).snapshots(),
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

class postRow extends StatelessWidget {

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



    final subjectCardContent = Container(
      margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
      constraints: BoxConstraints.expand(),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Container(height: 4.0),

                Flexible(
                  child: Container(
                      margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                      //width: 280,
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          timeDiff() ?

                              Container(
                          child : Row(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0XFFB7C2F3),
                                  shape: BoxShape.circle,


                                ),
                                width: 8,
                                height: 8,
                              ),
                              Padding(padding: EdgeInsets.only(left: 5),),
                              Text(postList['title'], style: headerTextStyle),

                            ],
                          )
                              )


                        :

                          //new one
                          Text(postList['title'] , style: headerTextStyle),


                          Container(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text('댓글 ', style: TextStyle(
                                        color: postList['comments'] == '0'
                                            ? Colors.grey
                                            : Color(0xFF86a2ea),
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12),),
                                    Text(postList['comments'], style: TextStyle(
                                        color: postList['comments'] == '0'
                                            ? Colors.grey
                                            : Color(0xFF86a2ea),
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14),),
                                  ],
                                ),
                                Text(postList['time'],
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),)

                              ],
                            ),
                          )
                        ],
                      )),
                ),
                //Padding(padding: EdgeInsets.only(top: 4.0),),

                //Container(height: 3.0),

//                Text(postList['contents'], style: regularTextStyle),
//                Text(postList['name'], style: subHeaderTextStyle),

                Container(
                    margin: EdgeInsets.only(top: 15.0),
                    height: 2.0,

                    color: Color(0xffE6E7E8)
                ),

              ],
            ),
          ),

        ],
      ),
    );



    final subjectCard = GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => QnADetail(postList)));
        },
        child: Container(


          child: subjectCardContent,
          width: MediaQuery
              .of(context)
              .size
              .width,
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

    timeDiff();

    return Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: 70.0,
        margin: const EdgeInsets.symmetric(
          vertical: 0.0,
          horizontal: 0.0,
        ),
        child: Stack(
          children: <Widget>[
            subjectCard,
            //subjectThumbnail,
          ],
        )
    );
  }

  bool timeDiff() {

    var postDate = DateTime.parse(postList['adocumentID'].split(' ')[0]);
    var diff = DateTime.now().difference(postDate);
    if(int.parse(diff.toString().split(':')[0]) < 24 )
    return true;
    else return false;

  }


}
