import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hanster_app/studyList.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class Comment extends StatefulWidget {
  final FirebaseUser user;
  final String DocumentID;
  Comment(this.user, this.DocumentID);

  @override

  _CommentState createState() => _CommentState();
}



class _CommentState extends State<Comment> {
  //  final databaseReference = FirebaseDatabase.instance.reference();
  get result => null;

  @override

  @override
  Widget build(BuildContext context) {
    String temp = widget.user.toString();
    String name = temp.split("displayName: ")[1];
    name = name.split(", ")[0];
    String field = name.split('학')[0];
    String date = DateTime.now().toString();
    String uploadDate = date ;
    date = date.split(':')[0]+":"+date.split(':')[1];
    date = date.split('2019-')[1];
    String now = DateTime.now().toString().split('.')[1];
    var ctrl = TextEditingController();


    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset('assets/images/study_recruit.png', fit: BoxFit.contain,height: 35,alignment: Alignment.center,),
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
          // appBar 하단의 그림자 정도
        ),
        body:  StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('StudyGroup').where("documentID", isEqualTo: widget.DocumentID ).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return new Text('Loading...');
              List<dynamic> users = List.from(snapshot.data.documents[0]['users']);
              print("array length" + users.length.toString());

              return Container(
                  child: SingleChildScrollView(
                    child: Container(
                        color: Colors.white,
                        child: Column(
                            children: <Widget>[
                              Stack(
                                alignment: Alignment.centerLeft,
                                children: <Widget>[
                                  SizedBox(height: MediaQuery.of(context).size.height*0.15, width: MediaQuery.of(context).size.width),
                                  Positioned(left:25.0,child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(snapshot.data.documents[0]['day'] + " " + snapshot.data.documents[0]['time'], style: TextStyle(fontFamily: 'Nanumsquare',color: Color(0XFFB0C1EA),fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        width: 300,
                                        child: Text(snapshot.data.documents[0]['title'], style: TextStyle(fontFamily: 'Nanumsquare',fontSize: 20, fontWeight: FontWeight.bold,color: Color(0XFF414042)),),
                                      ),
                                      Text(snapshot.data.documents[0]['subtitle'], style: TextStyle(fontFamily: 'Nanumsquare',color: Color(0XFFA7A9AC), fontSize: 15, fontWeight: FontWeight.bold),)
                                    ],
                                  )
                                  ),
                                  Positioned(right: 25.0,
                                    child: Column(
                                      children: <Widget>[
                                        RaisedButton(
                                          child: Text("방나가기", style: TextStyle(fontFamily: 'Nanumsquare',color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                                          color: Color(0XFF939598),
                                          //                    color: Colors.black38,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0)
                                          ),
                                          onPressed: () {
                                            Alert(
                                              context: context,
                                              title: "방을 나가시겠습니까?",
                                              style: AlertStyle(isCloseButton: false),
                                              buttons: [
                                                DialogButton(
                                                  child: Text(
                                                    "확인",
                                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                                  ),
                                                  onPressed: () {
                                                    if(users.length == 1){

                                                      //Navigator.pop(context);
                                                      Navigator.of(context, rootNavigator: true).pop(result);
                                                      Firestore.instance.collection('StudyGroup').document(widget.DocumentID).delete();
                                                    }
                                                    else{
                                                    Firestore.instance.collection('StudyGroup').document(widget.DocumentID).updateData({ 'users' : FieldValue.arrayRemove([name.split('학')[0]])});
                                                    Firestore.instance.collection('StudyGroup').document(widget.DocumentID).updateData({ 'photoUrl' : FieldValue.arrayRemove([widget.user.photoUrl])});
                                                    }
                                                    //Navigator.pop(context);
                                                    Navigator.of(context, rootNavigator: true).pop(result);


                                                  },
                                                  color: Color.fromRGBO(183, 194, 243, 1.0),
                                                  radius: BorderRadius.circular(10.0),
                                                ),
                                                DialogButton(
                                                  child: Text(
                                                    "취소",
                                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                                  ),
                                                  onPressed: () => Navigator.of(context, rootNavigator: true).pop(result),
                                                  color: Color.fromRGBO(183, 194, 243, 1.0),
                                                  radius: BorderRadius.circular(10.0),
                                                ),
                                              ],
                                            ).show();
                                          },
                                        ),
                                        Text("멤버 " +users.length.toString()+"명", style: TextStyle(fontFamily: 'Nanumsquare',color: Color(0XFFA7A9AC), fontWeight: FontWeight.bold),),

                                      ],
                                    ),
                                  ),
                                ],

                              ),
                        Container(

                          alignment: Alignment(0.0, 0.0),
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: Color(0XFFF1F2F2)),
                          child:
                          Center(
                            child: CustomScrollView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              slivers: <Widget>[
                                SliverPadding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  sliver:  SliverList(
                                    delegate:  SliverChildBuilderDelegate(
                                          (context, index) =>
                                          Center(
                                            child: Container(
                                              child: Row(

                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  SizedBox(width:30, height: 30,child: CircleAvatar(backgroundImage: NetworkImage(widget.user.photoUrl) )),
                                                  Padding(padding: EdgeInsets.all(3),),
                                                  Text(users[index]),
                                                  Padding(padding: EdgeInsets.all(10),),
                                                ],
                                              ),
                                            ),
                                          ),
                                      childCount: users.length,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance.collection('Comment').where('group', isEqualTo: widget.DocumentID).snapshots(),
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) return new Text('Loading...');
                                    if (snapshot.data.documents.length == 0){
                                      return const Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "댓글이 없습니다.",
                                            style: TextStyle(fontFamily: 'Nanumsquare',fontSize: 30.0, color: Colors.grey),
                                          ),
                                        ),
                                      );
                                    }

                                    if (!snapshot.hasData) return new Text('Loading...');
                                    return SingleChildScrollView(
                                      child: Container(
                                          height: MediaQuery.of(context).size.height*0.5,

                                          child: ListView(  //이 예제는 그냥 데이터 가져와서 리스트뷰만드는 코드
                                            shrinkWrap: true,
                                            children: snapshot.data.documents.map((DocumentSnapshot document) {
//                                              print(document.documentID);
                                              return
                                                Card(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 13.0),
                                                    child: ListTile(
                                                      title:
                                                      document['name'] != name ?
                                                      Stack(
                                                        alignment: Alignment.centerLeft,
                                                        children: <Widget>[
                                                          Positioned(
                                                            child: Row(
                                                              children: <Widget>[
                                                                SizedBox(width:24, height: 24,child: CircleAvatar(backgroundImage: NetworkImage(widget.user.photoUrl), )),
                                                                Padding(padding: EdgeInsets.all(3)),
                                                                Text(document['name'], style: TextStyle(fontFamily: 'Nanumsquare',fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF939598)),),
                                                              ],
                                                            ),
                                                          ),
                                                          Positioned(right:5.0, child: Text(timeDiff(document['date']) ?  document['date'].toString().split(' ')[1] : document['date'].toString().split(' ')[0], style: TextStyle(fontFamily: 'Nanumsquare',color: Color(0xFF939598)),),),
                                                        ],
                                                      ):
                                                      Stack(
                                                        alignment: Alignment.centerRight,
                                                        children: <Widget>[
                                                          Positioned(left:5.0, child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.start
                                                            ,
                                                            children: <Widget>[
                                                              Text(timeDiff(document['date']) ? document['date'].toString().split(' ')[1] : document['date'].toString().split(' ')[0], style: TextStyle(fontFamily: 'Nanumsquare',fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF939598)),),
                                                              FlatButton(onPressed: () {
                                                                Firestore.instance.collection('Comment').document(document.documentID).delete();
//
                                                                Alert(
                                                                  context: context,
                                                                  title: "댓글이 삭제되었습니다.",
                                                                  style: AlertStyle(isCloseButton: false),
                                                                  buttons: [
                                                                    DialogButton(
                                                                      child: Text(
                                                                        "확인",
                                                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                                                      ),
                                                                      onPressed: () {
                                                                        Navigator.of(context, rootNavigator: true).pop(result);
                                                                      },
                                                                      color: Color.fromRGBO(183, 194, 243, 1.0),
                                                                      radius: BorderRadius.circular(10.0),
                                                                    ),
                                                                  ],
                                                                ).show();
                                                              }, child: Text("삭제", style: TextStyle(fontFamily: 'Nanumsquare',fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF939598))))
                                                            ],
                                                          ),),

                                                          Positioned(
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: <Widget>[
                                                                SizedBox(width:24, height: 24,child: CircleAvatar(backgroundImage: NetworkImage(widget.user.photoUrl), )),
                                                                Padding(padding: EdgeInsets.all(3)),
                                                                Text(document['name'], style: TextStyle(fontFamily: 'Nanumsquare',fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF939598)),),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      subtitle: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Stack(alignment: document['name'] != name ? Alignment.centerLeft : Alignment.centerRight, children: <Widget>[
                                                            document['name'] == name ?
                                                            Container(decoration: BoxDecoration(color: Color(0XFFFFF2B0),
                                                                borderRadius: BorderRadius.all(Radius.circular(12))),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(10.0),
                                                                  child: Text(document['body'],
                                                                    style: TextStyle(fontFamily: 'Nanumsquare',fontSize: 17),),
                                                                )):

                                                            Container(decoration: BoxDecoration(color: Color(0XFFE1ECFF),
                                                                borderRadius: BorderRadius.all(Radius.circular(12))),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(10.0),
                                                                  child: Text(document['body'],
                                                                    style: TextStyle(fontFamily: 'Nanumsquare',fontSize: 17),),
                                                                )),
                                                          ],)),
                                                    ),
                                                  ),
                                                );
                                            }).toList(),
                                          )
                                      ),
                                    );

                                  }
                              ),

                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  decoration: BoxDecoration(border: Border.all(color: Color(0XFFB7C2F3)),
                                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                  child: Row(children: <Widget>[
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(

                                          controller: ctrl,
//
//                                          onChanged: (String str) {
//                                            setState(() => body = str,);
//                                          },
                                          decoration:
                                          InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "  댓글입력",
                                            hintStyle: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: SizedBox(
                                        width: 60,
                                        child: RaisedButton(
                                          child: Text("전송", style: TextStyle(fontFamily: 'Nanumsquare',color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                                          color: Color(0XFFB7C2F3),
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0)
                                          ),
                                          onPressed: () {
//                                            print(body);
                                            Firestore.instance.collection('Comment').document(DateTime.now().toString()).setData({
                                              'name' : name,
                                              'date' : uploadDate.split('.')[0],
                                              'body' : ctrl.text,
                                              'group' : widget.DocumentID,
                                            });

                                            Alert(
                                              context: context,
                                              title: "댓글이 등록되었습니다.",
                                              style: AlertStyle(isCloseButton: false),
                                              buttons: [
                                                DialogButton(
                                                  child: Text(
                                                    "확인",
                                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      ctrl.text = "test";
                                                    });

                                                    Navigator.of(context, rootNavigator: true).pop(result);
                                                  },
                                                  color: Color.fromRGBO(183, 194, 243, 1.0),
                                                  radius: BorderRadius.circular(10.0),
                                                ),
                                              ],
                                            ).show();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],),
                                ),
                              ),
                            ]
                        )
                    ),
                  )
              );
            }
        )
    );
  }



  bool timeDiff(String date) {

    var postDate = DateTime.parse(date.split(' ')[0]);
    var diff = DateTime.now().difference(postDate);
    if(int.parse(diff.toString().split(':')[0]) < 24 )
      return true;
    else return false;

  }


}