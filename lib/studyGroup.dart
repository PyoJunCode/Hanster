import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hanster_app/studyComment.dart';
import 'package:hanster_app/studyCreate.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StudyGroup extends StatefulWidget {
  final FirebaseUser user;
  final String sub;
  StudyGroup(this.user, this.sub);


  @override
  _StudyGroupState createState() => _StudyGroupState();
}
class Item {
  Item({
    this.isExpanded = false,
  });
  bool isExpanded;
}
List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Item(
      isExpanded: false,
    );
  });
}


class _StudyGroupState extends State<StudyGroup> {
  String name;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
//    bool _isExpanded = true;
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0XFFB7C2F3),
        accentColor: Colors.white,

      ),
      home: Scaffold(

        appBar: AppBar(
            centerTitle: true,
            title:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Image.asset('assets/images/study_recruit.png' , height: 30,),
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
        ),

        body: ModalProgressHUD(
          child: StreamBuilder<QuerySnapshot>(

            stream: Firestore.instance.collection('StudyGroup').where("subject", isEqualTo: widget.sub.split('. ')[1].trim()).orderBy("documentID", descending: true).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                //print(snapshot.data.documents.length);
                loading = true;
                return Container();
              }

              else {
                loading = false;
                return
                  ModalProgressHUD(
                    child: Column(
                        children: <Widget>[
                          Material(
                            borderOnForeground: true,
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: <Widget>[
                                SizedBox(height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.15, width: MediaQuery
                                    .of(context)
                                    .size
                                    .width),
//                          Positioned(left: 0, bottom: 0, child: Icon(Icons.star, size: 50)), // positioned left, bottom
//                          Positioned(right: 0, bottom: 0, child: Icon(Icons.star, size: 50))
                                Positioned(left: 25.0, child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 280,
                                      child: Text(
                                        widget.sub.split('. ')[1].trim(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontFamily: 'Nanumsquare',
                                            color: Color(0XFF86A2EA),
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.clip,),
                                    ),
                                    Text(widget.sub.split('.')[0].trim(),
                                      style: TextStyle(
                                          fontFamily: 'Nanumsquare',
                                          color: Color(0XFFA7A9AC),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),)
                                  ],
                                )),

//                             Text('Some lengthy text for testing'),

                                Positioned(right: 25.0,
                                  child: RaisedButton(
                                    child: Text("방만들기", style: TextStyle(
                                        fontFamily: 'Nanumsquare',
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                    color: Color(0XFFF9BE06),
                                    //                    color: Colors.black38,
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            15.0)
                                    ),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => CreatePage(
                                              widget.user, widget.sub)));
                                    },
                                  ),)
                              ],

                            ),
                          ),
                          Material(
                            elevation: 1.0,
                            child: SizedBox(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("총 ", style: TextStyle(fontSize: 20,
                                      fontFamily: 'Nanumsquare',
                                      fontWeight: FontWeight.bold,
                                      color: Color(0XFFA7A9AC)),),
                                  Text(
                                    snapshot.data.documents.length.toString(),
                                    style: TextStyle(fontFamily: 'Nanumsquare',
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0XFF86A2EA)),),
                                  Text("개의 스터디 ", style: TextStyle(
                                      fontFamily: 'Nanumsquare',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0XFFA7A9AC)),),
                                ],
                              ),
                            ),
                          ),


                          Expanded(
                            child: ListView.builder(
                              //                scrollDirection: Axis.vertical,

                              shrinkWrap: true,
                              //                padding: EdgeInsets.all(5.0),
                              itemBuilder: (context, index) {
                                //                  if(snapshot.data.documents[index]['count'] == snapshot.data.documents[index]['total']){
                                //                    run = true;}
//                            print(snapshot.data.documents[index].documentID);
                                String total = snapshot.data
                                    .documents[index]['total'];
//                          final Key topKey = UniqueKey();
                                const Key defaultKey = PageStorageKey<String>(
                                    'default');

                                return Card(
                                  //                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                  //                    elevation: 8.0,
                                  //                    margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                                    child: ExpansionTile(
                                      //                        contentPadding: EdgeInsets.only(top: 6, bottom: 6),
                                      key: defaultKey,
                                      title: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: <Widget>[
                                          SizedBox(width: MediaQuery
                                              .of(context)
                                              .size
                                              .width, height: 80,),
                                          Positioned(child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Text(snapshot.data
                                                      .documents[index]['title'],
                                                    style: TextStyle(
                                                        fontFamily: 'Nanumsquare',
                                                        fontSize: 20,
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        color: Color(
                                                            0XFF414042)),
                                                    textAlign: TextAlign
                                                        .center,),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),),
                                                  Container(
                                                    height: 30,


                                                    padding: EdgeInsets
                                                        .fromLTRB(5, 5, 5, 5),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Color(
                                                              0XFFEAEDF9)),
                                                      borderRadius: BorderRadius
                                                          .circular(10),
                                                      color: Color(0XFFEAEDF9),
                                                    ),
                                                    child: Text(snapshot.data
                                                        .documents[index]['day']
                                                        .trim() + " " +
                                                        snapshot.data
                                                            .documents[index]['time'],
                                                      style: TextStyle(
                                                          color: Color(
                                                              0XFFA7A9AC),
                                                          fontFamily: 'Nanumsquare',
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          fontSize: 15),
                                                      textAlign: TextAlign
                                                          .center,),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8),),
                                            ],
                                          ),
                                          ),
                                          Positioned(left: 0,
                                            top: 50,
                                            child: Text(snapshot.data
                                                .documents[index]['prof'] +
                                                "교수님", style: TextStyle(
                                                fontFamily: 'Nanumsquare',
                                                fontSize: 15,
                                                color: Color(0XFFA7A9AC)),
                                                textAlign: TextAlign.left),),
                                          Positioned(
                                            top: 40, right: 0, child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(

                                                child: StreamBuilder<
                                                    QuerySnapshot>(
                                                    stream: Firestore.instance
                                                        .collection(
                                                        'StudyGroup')
                                                        .where(snapshot.data
                                                        .documents[index]['documentID'])
                                                        .orderBy('documentID',
                                                        descending: true)
                                                        .snapshots(),
                                                    builder: (
                                                        BuildContext context,
                                                        AsyncSnapshot<
                                                            QuerySnapshot> snapshot) {
                                                      if (!snapshot.hasData)
                                                        return new Text(
                                                            'Loading...');
                                                      List<dynamic> users = List
                                                          .from(snapshot.data
                                                          .documents[index]['users']);
                                                      int count = users.length;

                                                      return Text(
                                                        count.toString() + '/' +
                                                            total + ' 명',
                                                        style: TextStyle(
                                                            fontFamily: 'Nanumsquare',
                                                            fontSize: 18,
                                                            fontWeight: FontWeight
                                                                .bold,
                                                            color: Color(
                                                                0XFF86A2EA)),
                                                        textAlign: TextAlign
                                                            .right,);
                                                    }
                                                )
//                                              child: Text(snapshot.data.documents[index]['count'] + '/' + snapshot.data.documents[index]['total'], style: TextStyle(fontFamily: 'Nanumsquare',fontSize: 25, fontWeight: FontWeight.bold,
//                                                  color: Color(0XFF86A2EA)),

                                            ),
                                          ),
                                          ),
                                        ],
                                      ),
                                      children: <Widget>[
                                        ListTile(
                                          title: Container(
                                            decoration: BoxDecoration(
                                                border: Border(top: BorderSide(
                                                    color: Colors.black12))
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .only(top: 8.0,
                                                      left: 15,
                                                      right: 15,
                                                      bottom: 8),
                                                  child: Text(snapshot.data
                                                      .documents[index]['intro'],
                                                    style: TextStyle(
                                                        fontFamily: 'Nanumsquare'),),
                                                ),
                                                RaisedButton(
                                                  //누르면 field의 이름이 누른 사람의 학번으로, 내용은 그냥 0이나 아무거나
                                                  child: Text("  참여하기  ",
                                                      style: TextStyle(
                                                          fontFamily: 'Nanumsquare',
                                                          color: Color(
                                                              0XFFF9BE06),
                                                          fontSize: 15,
                                                          fontWeight: FontWeight
                                                              .bold)),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(15.0),
                                                    side: BorderSide(
                                                        color: Color(
                                                            0XFFF9BE06)),
                                                  ),
                                                  onPressed: () {
                                                    String temp = widget.user
                                                        .toString();
                                                    name = temp.split(
                                                        "displayName: ")[1];
                                                    name = name.split(", ")[0];
                                                    name = name.split("학")[0];


                                                    Firestore.instance
                                                        .collection(
                                                        'StudyGroup')
                                                        .document(snapshot.data
                                                        .documents[index]['documentID'])
                                                        .updateData({
                                                      'users': FieldValue
                                                          .arrayUnion([name]),
                                                    });


                                                    Firestore.instance
                                                        .collection(
                                                        'StudyGroup')
                                                        .document(snapshot.data
                                                        .documents[index]['documentID'])
                                                        .updateData({
                                                      'photoUrl': FieldValue
                                                          .arrayUnion([
                                                        widget.user.photoUrl
                                                      ]),
                                                    });

                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (
                                                                context) =>
                                                                Comment(
                                                                    widget.user,
                                                                    snapshot
                                                                        .data
                                                                        .documents[index]['documentID'])));
//


//                                                  print(snapshot.data.documents[index].data.keys);
                                                  },
                                                  color: Colors.white,
                                                ),

                                              ],
                                            ),
                                          ),
                                          //                              enabled: _act==2,
                                        ),

                                      ],
                                      initiallyExpanded: false,
                                      trailing: Icon(Icons.keyboard_arrow_down),

                                      //                      Icons.keyboard_arrow_down
                                    ));
                              },
                              itemCount: snapshot.data.documents.length,
                            ),
                          ),
                        ]
                    ),
                    inAsyncCall: loading,);
              }
            },
          ),
        inAsyncCall: loading,),
        backgroundColor: Colors.white,
      ),
    );
  }

}


