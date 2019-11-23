import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hanster_app/qnaSubject.dart';
import 'package:hanster_app/studylist.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as Dom;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'assignment.dart';


class menuPage extends StatefulWidget {

  final FirebaseUser user;
  menuPage(this.user);

  @override
  _menuPageState createState() => _menuPageState();
}

class _menuPageState extends State<menuPage> {
  bool loading = true;
  List<Dom.Element> links = [];
  List<String> parseLinks = [];

  void initState(){
    super.initState();
    _makePutRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: Image.asset('assets/images/H_lo.png', fit: BoxFit.contain,height: 25,alignment: Alignment.center,),
          actions: <Widget>[
            Container(
                width: 50,
                height: 50,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 22.0,
                      backgroundColor: Colors.white,
                    ),
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(widget.user.photoUrl),
                    ),
                    Container(
                        alignment: Alignment.topRight,
                        child: Image.asset('assets/images/book.png')),
                  ],
                )
            ),
          ],
        ),
        backgroundColor: const  Color(0xFFffffffff),
        body : buildbody(context)

    );
  }

  Future _makePutRequest() async {
    String hakbun = widget.user.email.split('@')[0];
    List encodedText = utf8.encode(hakbun);
    // set up PUT request arguments
    String url = 'http://smart.handong.edu/mnotice/index.php/main/lookup_lists/' + base64.encode(encodedText) + '/NB0001/';
    Map<String, String> headers = { 'User-Agent' : 'Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B137 Safari/601.1'};
    // make PUT request
    Response response = await post(url, headers: headers);
    var document = parse(utf8.decode(response.bodyBytes));
    links = document.querySelectorAll('#BasicDemo > table > thead > tr > th > table > tbody > tr');
    setState(() {
      for(Dom.Element ele  in links){
        if(ele.text.contains('제목'))
          continue;
        parseLinks.add(ele.text);
      }
    });
  }


  buildbody(BuildContext context) {
    if(parseLinks.length != 0) setState(() {
      loading = false;
    });
    var firstDay = new DateTime.utc(2019, DateTime.august,26);
    Duration differ = DateTime.now().difference(firstDay);
    double week = differ.inDays.toInt()/7.0+1;
    return Scaffold(
        backgroundColor: const Color(0xff0000),
        body: Container(
          alignment: Alignment.topLeft,
          child: Column(
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width*1.0,
                    height: MediaQuery.of(context).size.height*0.057,
                    color: Color(0xffB7C2F3),
                    child:Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:8.0),
                        ),
                        Stack(
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.bottomCenter,
                                width: MediaQuery.of(context).size.width*0.5,
                                height: MediaQuery.of(context).size.height*0.4,
                                decoration: new BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: new BorderRadius.only(
                                        topLeft:  const  Radius.circular(10.5),
                                        topRight: const  Radius.circular(10.5))
                                ),
                              ),
                              new Text(DateTime.now().year.toString() + "." + DateTime.now().month.toString() + "." + DateTime.now().day.toString(),
                                style: TextStyle(fontFamily: 'Nanumsquare',fontWeight: FontWeight.bold, fontSize: 24, color: const Color(0xff86A2EA),),),
                            ]
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:16.0),
                        ),
                        Container(
                            child:new Text(week.round().toString()+'주차 ',
                              style: TextStyle(fontFamily: 'Nanumsquare',fontWeight: FontWeight.bold, fontSize: 22, color: const Color(0xffffffff),),)
                        )
                      ],
                    )
                ),
                Padding(padding: const EdgeInsets.only(top:32.0, left: 16.0, right:16.0),),
                Container(
                  alignment: Alignment.bottomLeft,
                  width: MediaQuery.of(context).size.width*1.0,
                  height: MediaQuery.of(context).size.height*0.05,
                  padding:  const EdgeInsets.only(left:30.0),
                  child: Text("최근공지 ", style: TextStyle(fontFamily: 'Nanumsquare',fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xff414042)),
                    textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:16.0),
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.95,
                  height: MediaQuery.of(context).size.height*0.001,
                  child: new Divider(
                    color: Color(0xff414042),
                  ),
                ),
                Flexible(
                  child: ModalProgressHUD(
                      child: loading?
                      Container(
                        color: Colors.white,
                      ):
                      Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width*1.0,
                          child: ListView.builder(
                              itemCount: 5,
                              itemBuilder: (BuildContext context, int index)  {

                                return parseLinks[index].split(']')[1].contains('[')? tempForList(parseLinks[index]): tempFordiffer(parseLinks[index]);
                              }
                          )
                      ),
                      inAsyncCall: loading),
                ),
                Container(
                  child: Material(
                    child: InkWell(
                      onTap: () =>   Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => qnaSubjectPage(widget.user)),
                      ),
                      child: Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width*1.0,
                          height: MediaQuery.of(context).size.height*0.13,
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  child:Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left:32.0),
                                      ),
                                      Text(
                                        'QnA',style: TextStyle(fontFamily: 'Nanumsquare',fontSize: 37, fontWeight: FontWeight.w900, color: Color(0xffB7C2F3),
                                          shadows: [
                                            Shadow(
                                              blurRadius: 1.0,
                                              color: Colors.white,
                                              offset: Offset(5.0,5.0),
                                            )
                                          ]),
                                      ),
                                    ],
                                  )
                              ),
                              Container(
                                  child:IconButton(
                                    icon: Icon(Icons.arrow_forward_ios,color: Color(0xfff9BE06),),
                                  )
                              ),
                            ],
                          )
                      ),
                    ),
                    color: Colors.transparent,
                  ),
                  color: Color(0xffEAEDF9),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                ),
                Container(
                  child: Material(
                    child: InkWell(
                      onTap: () =>   Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StudyList(widget.user) ),
                      ),
                      child: Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width*1.0,
                          height: MediaQuery.of(context).size.height*0.13,
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  child:Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left:32.0),
                                      ),
                                      Text(
                                        '스터디모집 ',style: TextStyle(fontFamily: 'Nanumsquare',fontSize: 37, fontWeight: FontWeight.w900, color: Color(0xffB7C2F3),
                                          shadows: [
                                            Shadow(
                                              blurRadius: 1.0,
                                              color: Colors.white,
                                              offset: Offset(5.0,5.0),
                                            )
                                          ]),
                                      ),
                                    ],
                                  )
                              ),
                              Container(
                                  child:IconButton(
                                    icon: Icon(Icons.arrow_forward_ios,color: Color(0xfff9BE06),),
                                  )
                              ),
                            ],
                          )
                      ),
                    ),
                    color: Colors.transparent,
                  ),
                  color: Color(0xffEAEDF9),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                ),
                Container(
                  child: Material(
                    child: InkWell(
                      onTap: () =>   Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => assign(widget.user)),
                      ),
                      child: Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width*1.0,
                          height: MediaQuery.of(context).size.height*0.13,

                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  child:Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left:32.0),
                                      ),
                                      Text(
                                        '과제관리 ',style: TextStyle(fontFamily: 'Nanumsquare',fontSize: 37, fontWeight: FontWeight.w900, color: Color(0xffB7C2F3),
                                          shadows: [
                                            Shadow(
                                              blurRadius: 1.0,
                                              color: Colors.white,
                                              offset: Offset(5.0,5.0),
                                            )
                                          ]),
                                      ),
                                    ],
                                  )
                              ),
                              Container(
                                  child:IconButton(
                                    icon: Icon(Icons.arrow_forward_ios,color: Color(0xfff9BE06),),
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => assign(widget.user)),
                                      );
                                    },
                                  )
                              ),
                            ],
                          )
                      ),
                    ),
                    color: Colors.transparent,
                  ),
                  color: Color(0xffEAEDF9),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                ),
                Container(
                  width: MediaQuery.of(context).size.width*1.0,
                  height: MediaQuery.of(context).size.height*0.06,
                  color: Color(0xffB7C2F3),
                )
              ]
          ),
        )
    );
  }
  tempFordiffer(String subject){
    String cont = subject.split('조회수:')[1].trim();
    int i = 0;
    while(true){
      if(isInt(cont[i]) == true) i++;
      else break;
    }
    String contf = cont.split(cont[i-1]+' ')[1].trim();

    return  Container(
      width: MediaQuery.of(context).size.width*1.0,
      alignment: Alignment.topLeft,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top:10.0,left: 16.0),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
              ),
              Text('미분류' ,style: TextStyle(fontFamily: 'Nanumsquare',color: Color(0xff7896EA), fontWeight: FontWeight.bold),),
              Text(' | '),
              Text(contf,style: TextStyle(fontFamily: 'Nanumsquare',color: Color(0xff000000)),)
            ],
          )
        ],
      ),
    );
  }

  tempForList(String subject){
    String major = subject.split('[')[2].trim();
    String major_no = major.split(']')[0].trim();
    String cont = major.split(']')[1].trim();
    return Container(
      width: MediaQuery.of(context).size.width*1.0,
      alignment: Alignment.topLeft,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top:10.0,left: 16.0),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
              ),
              Text(major_no,style: TextStyle(fontFamily: 'Nanumsquare',color: Color(0xff7896EA), fontWeight: FontWeight.bold),),
              Text(' | '),
              Text(cont,style: TextStyle(fontFamily: 'Nanumsquare',color: Color(0xff000000)),)
            ],
          )
        ],
      ),
    );
  }


  bool isInt(String str) {
    if(str == null)
    { return false;
    }
    return int.tryParse(str) != null;
  }

}