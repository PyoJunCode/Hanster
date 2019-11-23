import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:hanster_app/qnaList.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as Dom;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class writeQnaPage extends StatefulWidget {
  final FirebaseUser user;
  final String select;

  writeQnaPage(this.user, this.select);

  @override
  _writeQnaState createState() => _writeQnaState();
}

final textEditingController = TextEditingController();

var day="";
String intro;
String Prof;
String section;
var time;
String temp;
String title;
String subtitle;
String total;
int length=7;
List<int> _list = [0,0,0,0,0,0];

//String dropdownValue = '선택';
String time1, time2;

class _writeQnaState extends State<writeQnaPage> {

  String selectedClass;
  bool loading = true;
  List<Dom.Element> links = [];
  List<String> parseLinks = [];
  BuildContext ctx;
  File _image;
  List<String> Sub = [];
  List<DropdownMenuItem<String>> Section = [];


  void initState() {
    super.initState();
    _makePutRequest();
  }


  @override

  void dispose() {
    // TODO: implement dispose
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    if(parseLinks.length != 0)  setState(() {
      loading = false;
    });
    Sub = [];
    for(int i=0 ; i<parseLinks.length ; i++){
//      mail= user.email.split('@')[1];
//      Sub.add(new DropdownMenuItem(child: Text(parseLinks[i].split(' ')[1])));
      Sub.add(parseLinks[i].split(' ')[1]);
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



    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),

//      floatingActionButton:  FloatingActionButton.extended(onPressed: (){
//
//      }, label: Text('등록'),
//        icon: Icon(Icons.save),
//
//      ),

      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topLeft,

          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height*0.85, width: MediaQuery.of(context).size.width,
            ),


             Container(

              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 10) ),
                  Container(
                    decoration: BoxDecoration(

                        color:  Color(0xFFFFFFFF)   ,
                        shape: BoxShape.rectangle,

                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                            offset: Offset(0.0, 10.0),
                          )
                        ]
                    ),

                    margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment(0.0,0.0),
                          height: 50,
                          margin: EdgeInsets.fromLTRB(10, 15, 5, 5),
                          child: TextField(
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                            decoration: InputDecoration(

                                hintText: '질문 제목',
                                hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0XFFA7A9AC)),
                                border: InputBorder.none
                            ),

                            maxLength: 20,
                            onChanged: (String str) {
                              setState(() => title = str);
                            },
                          ),
                        ),

                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10),),
                  Container(
                    decoration: BoxDecoration(
                        //border: Border.all(color:  Color(0xFFe6e7e8), width: 2),

                        color:  Color(0xFFFFFFFF)   ,
                        shape: BoxShape.rectangle,

                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                            offset: Offset(0.0, 10.0),
                          )
                        ]
                    ),
                    margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ChangeButtonBackground('과제 관련',0),
                        Padding(padding: EdgeInsets.all(7),),
                        ChangeButtonBackground('수업 관련',1),
                        Padding(padding: EdgeInsets.all(7),),
                      ],
                    ),
                  ),

                  //Padding(padding: EdgeInsets.only(top: 15),),
                  Container(
                    height: MediaQuery.of(context).size.height*0.85 - 100,
                    margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
                    decoration: BoxDecoration(

                        color:  Color(0xFFFFFFFF)   ,
                        shape: BoxShape.rectangle,

                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                            offset: Offset(0.0, 10.0),
                          )
                        ]
                    ),
                    //height: 200,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
                        child: TextField(
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                          maxLength: 200,
                          maxLines: 20,
                          decoration: InputDecoration(

                            //labelText: '입력'
                            hintText: '질문 내용',
                            hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0XFFA7A9AC)),
                            border: InputBorder.none,
                          ),
                          cursorColor: Colors.purple,
                          onChanged: (String str) {
                            setState(() => intro = str);
//                                          print(intro);
                          },
                        ),
                      ),

                  ),

                ],
              ),
            ),

            Positioned(bottom:10, right:0,child: FlatButton(
              child: Text("등록 > ", style: TextStyle(color: Color(0XFFF9BE06), fontSize: 25, fontWeight: FontWeight.bold)),
//                      color: Color(0XFFF9BE06),
              color: Colors.white,
//                      textColor: Colors.white
              onPressed: () {

                String Documentid = DateTime.now().toString();
                Firestore.instance.collection('QNA').document(Documentid).setData({
                  'time': DateTime.now().month.toString() +'/'+DateTime.now().day.toString(),
                  'contents': intro,
                  'class': widget.select,
                  'qabout': total,
                  'title' : title,
                  'adocumentID' : Documentid,
                  'name' : widget.user.displayName,
                  'writer' : widget.user.displayName,
                  'comments' : '0',
                });
                Alert(
                  context: context,
                  title: "글이 등록되었습니다.",
                  style: AlertStyle(isCloseButton: false),
                  buttons: [
                    DialogButton(
                      child: Text(
                        "확인",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {

                        Navigator.of(context, rootNavigator: true).pop();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => qnaPage(widget.user, widget.select)));
                      },
                      color: Color.fromRGBO(183, 194, 243, 1.0),
                      radius: BorderRadius.circular(10.0),
                    ),
                  ],
                ).show();
              },
            ),)



          ],

        ),
      ),
    );
  }

  Future _makePutRequest() async {
    String hakbun = widget.user.email.split('@')[0];
    List encodedText = utf8.encode(hakbun);

    String url = 'http://smart.handong.edu/lecture_notice/index.php/main/lookup_lists/' + base64.encode(encodedText) + '/v6/';
    Map<String, String> headers = { 'User-Agent' : 'Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B137 Safari/601.1'};
    // make PUT request
    Response response = await post(url, headers: headers);
    var document = parse(utf8.decode(response.bodyBytes));

    links = document.querySelectorAll('#myClass > option');

    setState(() {
      for(Dom.Element ele  in links){
        if(ele.text.contains('공동') || ele.text.contains('채플'))
          continue;

        parseLinks.add(ele.text);
      }
    });

    parseLinks.removeAt(0);
  }

}



class MyCard extends StatelessWidget {
  MyCard( {this.title, this.icon });

  final Widget title;
  final Widget icon;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      padding: EdgeInsets.only(right: 3),

      child: Card(
        child: InkWell(
          child: this.title,
//          splashColor: Colors.pinkAccent,
          focusColor: Colors.pink,
          onTap: () {

          },
        ),
//        child: Container(
//          padding: EdgeInsets.all(5),
//          child: this.title
//        ),

      ),
    );
  }

}


class ChangeButtonBackground extends StatefulWidget {
  String title;
  int index;
  ChangeButtonBackground(this.title, this.index);

  @override
  ChangeButtonBackgroundState createState() {
    return new ChangeButtonBackgroundState();
  }
}

class ChangeButtonBackgroundState extends State<ChangeButtonBackground> {
  List<Color> _colors = [ //Get list of colors
    Colors.white,
    Color(0XFF86A2EA),
  ];

  int _currentIndex = 0;
  int _currentText = 1;

  _onChanged() { //update with a new color when the user taps button
    int _colorCount = _colors.length;
    setState(() {
      if (_currentIndex == 0) {
        _currentText = 0;
        _currentIndex = 1;
        _list[widget.index] = 1;
        total = widget.title;
        print(total);
//        print(widget.index);
      } else {
        _currentIndex = 0;
        _currentText = 1;
        _list[widget.index] = 0;
//        print(widget.index);
      }
    });

//    print(_currentIndex);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
//      height: 20,
      child: RaisedButton(
        child: Text(widget.title, style: TextStyle(color: _colors[_currentText], fontSize: 14, fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: Color(0XFF86A2EA))
        ),
        onPressed: _onChanged,
        color: _colors[_currentIndex],
      ),
//      child: RaisedButton(
//              child: Center(child: Text(widget.title)),
//              onPressed: _onChanged,
//              color: _colors[_currentIndex], //specify background color  of button from our list of colors
//            ),
    );
  }
}



Future check(BuildContext context, FirebaseUser user, String select, String DocumentId) async {

  await showDialog(
      context: context,
      child: SimpleDialog(
        title: Text('글이 등록되었습니다.'),
        children: <Widget>[
          SimpleDialogOption(child: Text('확인'),
            onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => qnaPage(user, select)));
          },
          )

        ],
      )
  );
}