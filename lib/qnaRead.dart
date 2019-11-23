import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
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

  List<Post> postMessages = List();

  Post post;

  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  DatabaseReference databaseReference;

  get result => null;

  @override
  void initState() {
    super.initState();

    post = Post("", "");
    databaseReference = database.reference().child(widget.DocumentID.split('.')[1]);
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
  }
  @override
  Widget build(BuildContext context) {
    String temp = widget.user.toString();
    String name = temp.split("displayName: ")[1];
    name = name.split(", ")[0];
    String field = name.split('학')[0];
    String date = DateTime.now().toString();
    date = date.split(':')[0]+":"+date.split(':')[1];
    date = date.split('2019-')[1];


    String now = DateTime.now().toString().split('.')[1];

    int i=3;

//        .child('recent')
//        .orderByChild('created_at')  //order by creation time.
//        .limitToFirst(10);           //l
//    return Text("WHy?????");
//
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset('image/logo.png', fit: BoxFit.contain,height: 35,alignment: Alignment.center,),
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
//                          Positioned(left: 0, bottom: 0, child: Icon(Icons.star, size: 50)), // positioned left, bottom
//                          Positioned(right: 0, bottom: 0, child: Icon(Icons.star, size: 50))
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
//                                    type: AlertType.,
                                              title: "방을 나가시겠습니까?",
//                                    desc: "FilledStacks.com has the best Flutter tutorials",
                                              style: AlertStyle(isCloseButton: false),
                                              buttons: [
                                                DialogButton(
                                                  child: Text(
                                                    "확인",
                                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    Firestore.instance.collection('Chatting').document(widget.DocumentID).updateData({field : FieldValue.delete()});
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
//                                        onPressed: () => Navigator.push(context, MaterialPageRoute(
//                                            builder: (context) => Comment(widget.user,widget.DocumentID))),

                                                  color: Color.fromRGBO(183, 194, 243, 1.0),
                                                  radius: BorderRadius.circular(10.0),
                                                ),
                                              ],
                                            ).show();

//                                  Navigator.pop(context);
                                          },
                                        ),
                                        StreamBuilder<QuerySnapshot>(

                                          //parseLinks[index].split('. ')[1]
                                            stream: Firestore.instance.collection('Chatting').where(widget.DocumentID).snapshots(),
                                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                                              if (!snapshot.hasData) return new Text('Loading...');
                                              List<String> list = snapshot.data.documents[0].data.keys.toList();
                                              int count = list.length;

                                              return Text("멤버 " + count.toString()+"명", style: TextStyle(fontFamily: 'Nanumsquare',color: Color(0XFFA7A9AC), fontWeight: FontWeight.bold),);

                                            }
                                        ),
                                      ],
                                    ),
                                  ),


                                ],

                              ),
                              StreamBuilder<QuerySnapshot>(

                                //parseLinks[index].split('. ')[1]
                                  stream: Firestore.instance.collection('Chatting').where(widget.DocumentID).snapshots(),
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) return new Text('Loading...');
                                    List<String> list = snapshot.data.documents[0].data.keys.toList();
                                    list.forEach((n)=>Text(n));
//                          print(list.length);

                                    return
                                      Container(
                                        height: 50,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(color: Color(0XFFF1F2F2)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                SizedBox(width:30, height: 30,child: CircleAvatar(backgroundImage: NetworkImage(widget.user.photoUrl), )),
                                                Padding(padding: EdgeInsets.all(3),),
                                                Text(list[0]),
                                              ],
                                            ),
                                            Padding(padding:EdgeInsets.all(8)),
                                            Row(
                                              children: <Widget>[
                                                SizedBox(width:30, height: 30,child: CircleAvatar(backgroundImage: NetworkImage(widget.user.photoUrl), )),
                                                Padding(padding: EdgeInsets.all(3),),
                                                Text(list[1]),
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                  }
                              ),
                              SingleChildScrollView(
                                child: Container(
                                  height: MediaQuery.of(context).size.height*0.5,
                                  child: FirebaseAnimatedList(
                                    query: databaseReference,
                                    shrinkWrap: true,
                                    itemBuilder: (_, DataSnapshot snapshot,
                                        Animation<double> animation, int index) {
                                      return Card(
                                        child: ListTile(
                                          title:
                                          postMessages[index].name != name ?
                                          Stack(
                                            alignment: Alignment.centerLeft,
                                            children: <Widget>[

                                              Positioned(
                                                child: Row(
                                                  children: <Widget>[
                                                    SizedBox(width:24, height: 24,child: CircleAvatar(backgroundImage: NetworkImage(widget.user.photoUrl), )),
                                                    Padding(padding: EdgeInsets.all(3)),
                                                    Text(postMessages[index].name, style: TextStyle(fontFamily: 'Nanumsquare',fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF939598)),),
                                                  ],
                                                ),
                                              ),

                                              Positioned(right:5.0, child: Text(postMessages[index].date, style: TextStyle(fontFamily: 'Nanumsquare',),),)
                                            ],
                                          ):
                                          Stack(
                                            alignment: Alignment.centerRight,
                                            children: <Widget>[

                                              Positioned(left:5.0, child: Text(postMessages[index].date, style: TextStyle(fontFamily: 'Nanumsquare',),),),

                                              Positioned(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    SizedBox(width:24, height: 24,child: CircleAvatar(backgroundImage: NetworkImage(widget.user.photoUrl), )),
                                                    Padding(padding: EdgeInsets.all(3)),
                                                    Text(postMessages[index].name, style: TextStyle(fontFamily: 'Nanumsquare',fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF939598)),),
                                                  ],
                                                ),
                                              ),


                                            ],
                                          ),
                                          // value ?  :  ;
                                          subtitle: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Stack(alignment: postMessages[index].name != name ? Alignment.centerLeft : Alignment.centerRight, children: <Widget>[
                                                postMessages[index].name == name ?
                                                Container(decoration: BoxDecoration(color: Color(0XFFFFF2B0),
                                                    borderRadius: BorderRadius.all(Radius.circular(12))),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: Text(postMessages[index].body,
                                                        style: TextStyle(fontFamily: 'Nanumsquare',fontSize: 17),),
                                                    )):

                                                Container(decoration: BoxDecoration(color: Color(0XFFE1ECFF),
                                                    borderRadius: BorderRadius.all(Radius.circular(12))),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: Text(postMessages[index].body,
                                                        style: TextStyle(fontFamily: 'Nanumsquare',fontSize: 17),),
                                                    )),
                                              ],)),
                                        ),
                                      );
                                    },
                                  ),
                                ),
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
//                        controller: _textController,
                                          // 입력된 텍스트에 변화가 있을 때 마다
                                          onChanged: (String str) {
                                            setState(() => post.body = str);
                                          },
                                          // 키보드상에서 확인을 누를 경우. 입력값이 있을 때에만 _handleSubmitted 호출
//                        onSubmitted: _isComposing ? _handleSubmitted : null,
                                          // 텍스트 필드에 힌트 텍스트 추가
                                          decoration:
                                          InputDecoration(
                                            border: InputBorder.none,
//                            border: OutlineInputBorder(
//                              borderSide: BorderSide(color: Color(0XFFB7C2F3)),
//                                borderRadius: BorderRadius.all(Radius.circular(15.0))),
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
                                          //                    color: Colors.black38,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0)
                                          ),
                                          onPressed: () {
                                            FirebaseDatabase.instance.reference().child(widget.DocumentID.split('.')[1]).child(now)
                                                .update({
                                              'date': date,
                                              'name' : name,
                                              'body': post.body,
                                            });
//                                  createComment(date, name, post.body);
                                            Alert(
                                              context: context,
//                                    type: AlertType.,
                                              title: "댓글이 등록되었습니다.",
//                                    desc: "FilledStacks.com has the best Flutter tutorials",
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

  showAlertDialog(BuildContext context) {
//    print(post.body);

    // set up the button
    Widget okButton = FlatButton(
        child: Text("확인",  style: TextStyle(fontFamily: 'Nanumsquare',color: Color(0XFFB7C2F3), fontSize: 18, fontWeight: FontWeight.bold)),
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(result)
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("댓글이 등록되었습니다", style: TextStyle(fontFamily: 'Nanumsquare',color: Color(0XFFB7C2F3), fontSize: 22, fontWeight: FontWeight.bold)),
//      content: Text("This is my message."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _onEntryAdded(Event event) {
    setState(() {
      postMessages.add(Post.fromSnapshot(event.snapshot));
    });
  }

  void _submitPostForm() {
    final FormState state = formKey.currentState;

    if (state.validate()) {
      state.save();
      state.reset();

    }
  }

  void createComment(String time, String name, String body) {
    databaseReference.child(DateTime.now().toString()).set({
      'date' : time,
      'name' : name,
      'body' : body
    });
  }

  void _onEntryChanged(Event event) {
    var oldData = postMessages.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      postMessages[postMessages.indexOf(oldData)] =
          Post.fromSnapshot(event.snapshot);
    });
  }
}

class Post {
  String key;
  String subject;
  String body;
  String name;
  String date;

  Post(this.subject, this.body);

  Post.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        subject = snapshot.value["subject"],
        body = snapshot.value["body"],
        name = snapshot.value["name"],
        date = snapshot.value["date"];


  toJson() {
    return {"subject": subject, "body": body};
  }
}