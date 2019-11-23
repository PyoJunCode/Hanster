import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class QnADetail extends StatelessWidget {
  final DocumentSnapshot postList;
  var ctrl = TextEditingController();
  int count;

  QnADetail(this.postList);

  // BuildContext get context => null;

  get result => null;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBar(context),
      body: buildbody(context),
      backgroundColor: Colors.white,

    );
  }

  buildbody(context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('QNA').where('adocumentID', isEqualTo: postList['adocumentID']).snapshots(),
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: Stack(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Material(
                              elevation:5,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height*0.11,
                                color: Colors.white,

                                child: Padding(
                                  padding: const EdgeInsets.only(top: 15, left: 20, right:20),
                                  child: Stack(
                                    children: <Widget>[
                                      Text(postList['time'], style: TextStyle(color:Color(0XFFA7A9AC)),),
                                      Positioned(top: 20, child: Text(postList['title'], style: TextStyle(fontSize: 20, color: Colors.black ),)),
                                      Positioned(right:10, top: 20,child: Text("댓글 "+snapshot.data.documents[0]['comments'], style: TextStyle(fontSize: 15, color: Color(0xFFF9BE06), ),textAlign: TextAlign.right,)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              child: Container(

                                height: MediaQuery.of(context).size.height*0.25,
                                child: Padding(
                                  padding: const EdgeInsets.only(top :15.0, left: 15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[

                                      Text(postList['contents'], style: TextStyle(fontSize: 15),textAlign: TextAlign.left,),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: Color(0XFFD1D3D4)),
                                  ),

                                ),

                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
                                  child: Text("댓글 "+snapshot.data.documents[0]['comments'], style: TextStyle(fontSize: 20, color: Color(0xFFF9BE06)),),
                                )),


                            StreamBuilder<QuerySnapshot>(
                                stream: Firestore.instance.collection('QNA_comment').where('group', isEqualTo: postList['adocumentID']).snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                                  if (!snapshot.hasData) return new Text('Loading...');
                                  count = snapshot.data.documents.length;

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
                                        height: MediaQuery.of(context).size.height*0.3,

                                        child: ListView(
                                          shrinkWrap: true,
                                          children: snapshot.data.documents.map((DocumentSnapshot document) {

//
                                            return
                                              Card(
                                                child: ListTile(
                                                  title:
                                                  Stack(
                                                    alignment: Alignment.centerLeft,
                                                    children: <Widget>[
                                                      Text(document['contain']),
                                                    ],
                                                  ),
                                                ),
                                              );
                                          }).toList(),
                                        )
                                    ),
                                  );

                                }
                            ),
                          ],

                        ),

                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0XFFEAEDF9),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Row(children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: ctrl,
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
                        padding: const EdgeInsets.only(right:10.0, left: 10),
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
                              Firestore.instance.collection('QNA_comment').document(DateTime.now().toString()).setData({
                                'contain' : ctrl.text,
                                'group' : postList['adocumentID'],
                              });
                              Firestore.instance.collection('QNA').document(postList['adocumentID']).updateData({
                                'comments': (count+1).toString(),
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
              ],
            ),
          );
        }
    );
  }

  buildAppBar(context) {
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


}