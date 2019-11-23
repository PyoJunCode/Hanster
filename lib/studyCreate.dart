import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hanster_app/studygroup.dart';
import 'package:html/dom.dart' as Dom;
import 'package:rflutter_alert/rflutter_alert.dart';

class CreatePage extends StatefulWidget {
  final FirebaseUser user;
  final String select;

  CreatePage(this.user, this.select);

  @override
  _CreatePageState createState() => _CreatePageState();
}

final textEditingController = TextEditingController();

var day="";
String intro;
String Prof;
String section;
String subject;
var time;
String temp;
String title;
String subtitle;
String total;
int length=7;
List<int> _list = [0,0,0,0,0,0];
List<String> _total = ['3명', '4명', '5명', '6명', '7명', '8명'];

//String dropdownValue = '선택';
String time1, time2;

class _CreatePageState extends State<CreatePage> {

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

      Sub.add(parseLinks[i].split(' ')[1]);
    }
    String temp = widget.user.toString();
    String name = temp.split("displayName: ")[1];
    name = name.split(", ")[0];
    name = name.split("학")[0];

    buildAppBar() {
      return AppBar(
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
            Positioned(child: Container(
              decoration: BoxDecoration(border: Border.all(color:Colors.black12)),
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 10) ),
                  Container(

                    margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 40,
                          margin: EdgeInsets.fromLTRB(10, 15, 5, 0),
                          child: TextField(
                            style: TextStyle(fontFamily: 'Nanumsquare',fontSize: 20,  fontWeight: FontWeight.bold),
                            decoration: InputDecoration(

                                hintText: '스터디모집방 이름',
                                hintStyle: TextStyle(fontFamily: 'Nanumsquare',fontSize: 20, fontWeight: FontWeight.bold, color: Color(0XFFA7A9AC)),
                                border: InputBorder.none
                            ),
                            maxLength: 20,
                            onChanged: (String str) {
                              setState(() => title = str);
                            },
                          ),
                        ),
                        Container(
                            margin:  EdgeInsets.only(top: 15.0),
                            height: 2.0,

                            color:  Color(0xffE6E7E8)
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
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

                    child: Container(

                      margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
                      child: TextField(
                        style: TextStyle(fontFamily: 'Nanumsquare',fontSize: 15),
                        decoration: InputDecoration(

                            hintText: '서브타이틀',
                            hintStyle: TextStyle(fontFamily: 'Nanumsquare',fontSize: 15, color: Color(0XFFA7A9AC)),
                            border: InputBorder.none
                        ),
                        maxLength: 10,
                        onChanged: (String str) {
                          setState(() => subtitle = str);
                        },
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 5),),
                  Container(
                    color: Color(0xFFFFFFFF),
                    margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ChangeButtonBackground('3명',0),
                        Padding(padding: EdgeInsets.all(7),),
                        ChangeButtonBackground('4명',1),
                        Padding(padding: EdgeInsets.all(7),),
                        ChangeButtonBackground('5명',2),
                        Padding(padding: EdgeInsets.all(7),),
                        ChangeButtonBackground('6명',3),
                        Padding(padding: EdgeInsets.all(7),),
                        ChangeButtonBackground('7명',4),
                        Padding(padding: EdgeInsets.all(7),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
                      child: Row(
                        children: <Widget>[
                          Text('교수님 : ', style: TextStyle(fontFamily: 'Nanumsquare',fontSize: 16, color: Color(0XFFA7A9AC)),),
                          Container(
                            width: MediaQuery.of(context).size.width*0.5,
                            height: 30,
                            child: TextField(
                              decoration: InputDecoration(
                                //labelText: '입력'
                              ),
                              onChanged: (String str) {
                                setState(() => Prof = str);
                              },
                            ),
                          ),
//                                Text('교수님', style: TextStyle(fontSize: 10),)

                        ],
                      ),
                    ),
                  ),
                  Container(
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
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
                      child: Row(
                        children: <Widget>[
                          Text('시간대 : ', style: TextStyle(fontFamily: 'Nanumsquare',fontSize: 16, color: Color(0XFFA7A9AC))),
                          DropdownButton<String>(
                            items: [
                              DropdownMenuItem(
                                  value: "8시",
                                  child: Text('8시')
                              ),
                              DropdownMenuItem(
                                  value: "9시",
                                  child: Text('9시')
                              ),
                              DropdownMenuItem(
                                  value: "10시",
                                  child: Text('10시')
                              ),
                              DropdownMenuItem(
                                  value: "11시",
                                  child: Text('11시')
                              ),
                              DropdownMenuItem(
                                  value: "12시",
                                  child: Text('12시')
                              ),
                              DropdownMenuItem(
                                  value: "13시",
                                  child: Text('13시')
                              ),
                              DropdownMenuItem(
                                  value: "14시",
                                  child: Text('14시')
                              ),
                              DropdownMenuItem(
                                  value: "15시",
                                  child: Text('15시')
                              ),
                              DropdownMenuItem(
                                  value: "16시",
                                  child: Text('16시')
                              ),
                              DropdownMenuItem(
                                  value: "17시",
                                  child: Text('17시')
                              ),
                              DropdownMenuItem(
                                  value: "18시",
                                  child: Text('18시')
                              ),
                              DropdownMenuItem(
                                  value: "19시",
                                  child: Text('19시')
                              ),
                              DropdownMenuItem(
                                  value: "20시",
                                  child: Text('20시')
                              ),
                              DropdownMenuItem(
                                  value: "21시",
                                  child: Text('21시')
                              ),
                              DropdownMenuItem(
                                  value: "22시",
                                  child: Text('22시')
                              ),
                              DropdownMenuItem(
                                  value: "23시",
                                  child: Text('23시')
                              )
                            ],
                            onChanged: (value) {
                              setState(() {
                                time1 = value;
                                //                                        print(time1);
                              });
                            },
                            value: time1,
                            hint: Text('선택'),
                          ),
                          Padding(padding: EdgeInsets.all(8.0),),
                          Text(" ~ "),
                          DropdownButton<String>(
                            items: [
                              DropdownMenuItem(
                                  value: "8시",
                                  child: Text('8시')
                              ),
                              DropdownMenuItem(
                                  value: "9시",
                                  child: Text('9시')
                              ),
                              DropdownMenuItem(
                                  value: "10시",
                                  child: Text('10시')
                              ),
                              DropdownMenuItem(
                                  value: "11시",
                                  child: Text('11시')
                              ),
                              DropdownMenuItem(
                                  value: "12시",
                                  child: Text('12시')
                              ),
                              DropdownMenuItem(
                                  value: "13시",
                                  child: Text('13시')
                              ),
                              DropdownMenuItem(
                                  value: "14시",
                                  child: Text('14시')
                              ),
                              DropdownMenuItem(
                                  value: "15시",
                                  child: Text('15시')
                              ),
                              DropdownMenuItem(
                                  value: "16시",
                                  child: Text('16시')
                              ),
                              DropdownMenuItem(
                                  value: "17시",
                                  child: Text('17시')
                              ),
                              DropdownMenuItem(
                                  value: "18시",
                                  child: Text('18시')
                              ),
                              DropdownMenuItem(
                                  value: "19시",
                                  child: Text('19시')
                              ),
                              DropdownMenuItem(
                                  value: "20시",
                                  child: Text('20시')
                              ),
                              DropdownMenuItem(
                                  value: "21시",
                                  child: Text('21시')
                              ),
                              DropdownMenuItem(
                                  value: "22시",
                                  child: Text('22시')
                              ),
                              DropdownMenuItem(
                                  value: "23시",
                                  child: Text('23시')
                              )
                            ],
                            onChanged: (value) {
                              setState(() {
                                time2 = value;

                              });
                            },
                            value: time2,
                            hint: Text('선택'),
                          ),
                          Padding(padding: EdgeInsets.all(8.0),),
                        ],
                      ),
                    ),
                  ),

                  Padding(padding: EdgeInsets.only(top: 5),),
                  Container(
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
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(

                        maxLength: 200,
                        maxLines: 6,
                        decoration: InputDecoration(
                          //labelText: '입력'
                          hintText: '스터디모집방 소개',
                          hintStyle: TextStyle(fontFamily: 'Nanumsquare', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0XFFA7A9AC)),
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
            )
            ),
            Positioned(bottom:10, right:0,child: FlatButton(
              child: Text("등록 > ", style: TextStyle(fontFamily: 'Nanumsquare',color: Color(0XFFF9BE06), fontSize: 25, fontWeight: FontWeight.bold)),
//                      color: Color(0XFFF9BE06),
              color: Colors.white,
//                      textColor: Colors.white
              onPressed: () {
                time = "$time1~$time2";
                print(time);
                String Documentid = DateTime.now().toString();
                Firestore.instance.collection('StudyGroup').document(Documentid).setData({
                  'time': time,
                  'day': '월.목',
                  'intro': intro,
                  'subject': widget.select.split('. ')[1].trim(),
                  'prof': Prof,
                  'total': total,
                  'subtitle' : subtitle,
                  'title' : title,
                  'documentID' : Documentid,
                });

                Firestore.instance.collection('StudyGroup').document(Documentid).updateData({
                  'users': FieldValue.arrayUnion([name]),
                });


                Firestore.instance.collection('StudyGroup').document(Documentid).updateData({
                  'photoUrl': FieldValue.arrayUnion([widget.user.photoUrl]),
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
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudyGroup(widget.user, widget.select)));
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
        print(widget.title);
        total = widget.title.split('명')[0];

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
      width: 55,
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
