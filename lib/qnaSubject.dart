import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hanster_app/qna.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as Dom;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class qnaSubjectPage extends StatefulWidget {

  final FirebaseUser user;

  qnaSubjectPage(this.user);


  @override
  _qnaSubjectPageState createState() => _qnaSubjectPageState();
}

class _qnaSubjectPageState extends State<qnaSubjectPage> {

  String selectedClass  ;
  bool loading = true;
  List<Dom.Element> links = [];
  List<String> parseLinks = [];

  @override

  void initState(){
    super.initState();
    _makePutRequest();
  }
  Widget build(BuildContext context) {

    return Scaffold(

        //appBar: buildAppBar(),

        backgroundColor: const  Color(0xFF97AFB9),

        body : buildbody()

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

      links = document.querySelectorAll('#myClass > option');

     setState(() {
       for(Dom.Element ele  in links){
         parseLinks.add(ele.text);
       }
     });

     parseLinks.removeAt(0);


  }


  buildbody()  {



    if(parseLinks.length != 0) setState(() {
      loading = false;
    });


    return    ModalProgressHUD(
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(14.0),),
          Row(
            children: <Widget>[
              Container(

                  margin: EdgeInsets.only(left: 25.0),
                  decoration: BoxDecoration(
                      color: Color(0xFF333345),
                      shape: BoxShape.circle,
                      //borderRadius: BorderRadius.circular(8.0),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                          offset: Offset(0.0, 10.0),
                        )
                      ]
                  ),
                  child: IconButton(icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => qnaPage(widget.user, selectedClass)));
                  },)
              ),
              Padding(padding: EdgeInsets.only(left: 25.0),),
              Text('과목선택', style: TextStyle(color: Color(0xFF333345),
                fontSize: 23.0,
                fontWeight: FontWeight.w600))
            ],
          ),

          Expanded(
            child: Container(
                color:  Color(0xFF97AFB9),
                child:  CustomScrollView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: false,
                  slivers: <Widget>[
                     SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      sliver:  SliverList(
                        delegate:  SliverChildBuilderDelegate(
                              (context, index) =>  SubjectRow(parseLinks[index], widget.user),
                          childCount: parseLinks.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ),
        ],
      ),
      inAsyncCall: loading,);



  }


}


class Subject {

  final String className;

  const Subject({this.className});
}

class SubjectRow extends StatelessWidget{
  final String subject;
  final FirebaseUser user;

  SubjectRow(this.subject, this.user);

  @override
  Widget build(BuildContext context) {

    String subjectName = subject.split('.')[1].trim();
    String subjectCode = subject.split('.')[0].trim();

    final baseTextStyle = const TextStyle(
        fontFamily: 'Poppins'
    );
    final regularTextStyle = baseTextStyle.copyWith(
        color: const Color(0xffb6b2df),
        fontSize: 9.0,
        fontWeight: FontWeight.w400
    );
    final subHeaderTextStyle = regularTextStyle.copyWith(
        fontSize: 12.0
    );
    final headerTextStyle = baseTextStyle.copyWith(
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.w600
    );

    final subjectCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Container(height: 4.0),
          Row(
            children: <Widget>[
              Text(subjectName, style: headerTextStyle),
//              IconButton(icon: Icon(Icons.send),)
            ],
          ),
          new Container(height: 3.0),

          new Text(subjectCode, style: subHeaderTextStyle),
          new Container(
              margin: new EdgeInsets.symmetric(vertical: 2.0),
              height: 2.0,
              width: 70.0,
              color: new Color(0xff00c6ff)
          ),

        ],
      ),
    );

  final subjectCard = GestureDetector(
     onTap: (){
       Navigator.push(context, MaterialPageRoute(
           builder: (context) => qnaPage(user, subjectName)));
     },
     child: Container(
    child: subjectCardContent,
    height: 90.0,
    //margin: EdgeInsets.only(left: 46.0),
    decoration: BoxDecoration(
      color: Color(0xFF333345),
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
     )
  );


       return new Container(
             height: 90.0,
              margin: const EdgeInsets.symmetric(
            vertical: 3.0,
                horizontal: 24.0,
              ),
           child: new Stack(
            children: <Widget>[
              subjectCard,
              //subjectThumbnail,
            ],
          )
        );

      }
}





