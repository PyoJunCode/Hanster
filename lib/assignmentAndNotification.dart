import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as Dom;

class assignment_submit extends StatefulWidget {

  final FirebaseUser user;

  assignment_submit(this.user);

  @override
  _assignment_submitState createState() => _assignment_submitState();
}

class _assignment_submitState extends State<assignment_submit> {

  String selectedClass  ;
  bool loading = true;
  List<Dom.Element> links = [];
  List<String> parseLinks = [];

  List<DropdownMenuItem<int>> myclass=[];
  String dropdownValue = 'class1';

  void initState(){
    super.initState();
    _makePutRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const  Color(0xFFffffffff),
        body : buildbody(context)

    );
  }

  Future _makePutRequest() async {
    String hakbun = widget.user.email.split('@')[0];
    List encodedText = utf8.encode(hakbun);

    // set up PUT request arguments
    String url = 'http://smart.handong.edu/lecture_notice/index.php/main/lookup_lists/' + base64.encode(encodedText) + '/v6/';
    Map<String, String> headers = { 'User-Agent' : 'Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B137 Safari/601.1'};
    // make PUT request
    Response response = await post(url, headers: headers);
    var document = parse(utf8.decode(response.bodyBytes));
    links = document.querySelectorAll('#board_area > table > thead > tr > th > table > tbody > tr');
    setState(() {
      for(Dom.Element ele  in links){
        if(ele.text.contains('SUBMIT') || ele.text.contains('채플'))
          continue;
        parseLinks.add(ele.text.trim());
      }
    });
  }



  buildbody(BuildContext context) {
    if(parseLinks.length != 0) setState(() {
      loading = false;
    });
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(bottom: 16.0)),
            Flexible(
              child: Container(
                height: MediaQuery.of(context).size.height*1.0,
                width: MediaQuery.of(context).size.width*1.0,
                child: ListView.builder(
                    itemCount: parseLinks.length,
                    itemBuilder: (BuildContext context, int index) {
                      return  tempForList_se(parseLinks[index],index);
                    }
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }

  tempForList_se(String subject,int index){
    String subjectName = subject.split('\n')[1].trim();
    String subjectCode = subject.split('\n')[0].trim();
    String subjectDate = subject.split('\n')[2].trim();
    String submit = subject.split('\n')[4].trim();
    String first_time = subjectDate.split(DateTime.now().year.toString())[1].trim();
    String due_time = subjectDate.split(DateTime.now().year.toString())[2].trim();
    return Container(
      width: MediaQuery.of(context).size.width*0.95,
      height: MediaQuery.of(context).size.height*0.15,
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width*0.65,
                height: MediaQuery.of(context).size.height*0.1,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                    ),
                    Text((index+1).toString(),style: TextStyle(fontSize: 25.0,color: Color(0xffBCBEB0), fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.only(left: 26.0),
                    ),
                    Flexible(child: Text(subjectCode,style: TextStyle(fontSize: 17.0,color: Color(0xff414042), fontWeight: FontWeight.bold),)),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                    ),
                  ],
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width*0.3,
                  height: MediaQuery.of(context).size.height*0.1,
                  child: submit == '제출' ?  box_submit(submit,first_time,due_time) :  box_nosubmit(submit,first_time,due_time)
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
              ),
            ],
          ),
          Divider(color: Color(0xff86A2EA),),
        ],
      ),
    );
  }

}

box_nosubmit(String submit, String first_time, String due_time) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      // Text(DateTime.now().year.toString()+first_time,style: TextStyle(fontSize: 11.0),),
      Text(DateTime.now().year.toString()+due_time,style: TextStyle(fontSize: 14.0,color: Colors.black,)),
      Divider(color: Color(0xffBCBEB0),),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(submit + '    ',style: TextStyle(fontSize: 14.0,color: Color(0xff6D6E65),fontWeight: FontWeight.bold)),
        ],
      ),
    ],
  );
}


box_submit(String submit, String first_time, String due_time) {
  return
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //Text(DateTime.now().year.toString()+first_time,style: TextStyle(fontSize: 11.0),),
        Text(DateTime.now().year.toString()+due_time,style: TextStyle(fontSize: 14.0,color: Color(0xffBCBEC0))),
        Divider(color: Color(0xffBCBEB0),),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(submit +'완료'+ '    ',style: TextStyle(fontSize: 14.0,color: Color(0xfff9BE86),fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
}