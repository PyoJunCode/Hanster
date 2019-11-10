import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:hanster_app/login.dart';
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

        appBar: buildAppBar(),

        backgroundColor: const  Color(0xFFffffff),

        body : buildbody()

    );

  }

  Future _makePutRequest() async {

    String hakbun = widget.user.email.split('@')[0];
    List encodedText = utf8.encode(hakbun);

    String url = 'http://smart.handong.edu/lecture_notice/index.php/main/lookup_lists/' + base64.encode(encodedText) + '/v6/';

    Map<String, String> headers = { 'User-Agent' : 'Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B137 Safari/601.1'};


    Response response = await post(url, headers: headers); // 크롤링하는거


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


  buildbody()  {

    if(parseLinks.length != 0) setState(() {
      loading = false;
    });


    return    ModalProgressHUD(
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(14.0),),
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 25),),
                Text('과목을 선택해주세요', style:TextStyle(color: Color(0xFFa7a9ac),
                    fontSize: 23.0,
                    fontWeight: FontWeight.w600),
                ),
                IconButton(icon: Icon(Icons.chevron_right) , iconSize: 40,  onPressed: null)

              ],
            ),


          Expanded(
            child: Container(
                color:  Color(0xFFffffff),
                child:  CustomScrollView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: false,
                  slivers: <Widget>[
                     SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      sliver:  SliverList(
                        delegate:  SliverChildBuilderDelegate(
                              (context, index) => SubjectRow(parseLinks[index], widget.user),
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


  buildAppBar() {
    return GradientAppBar(
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(Icons.question_answer,color: Colors.yellow,size: 30,),
          Padding(padding: EdgeInsets.only(left: 10),),
          Text('QnA', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
      leading: Icon(Icons.chevron_left, color: Colors.white, size: 40,),
      backgroundColorStart: const Color(0xFFADB7F0) ,
      backgroundColorEnd: const Color(0xFF86a2c6),
      actions: <Widget>[


        Container(

            margin: EdgeInsets.only(left: 25.0),

            child: IconButton(icon: Icon(Icons.toc),
              iconSize: 40,
              color: Colors.white,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => loginPage()));
              },)
        ),

      ],
    );
  }

  void selectSubject(string){
    setState(() {
      selectedClass = string;

    });

  }


}



class SubjectRow extends StatefulWidget{

  final String subject;
  final FirebaseUser user;

  SubjectRow(this.subject, this.user);

  @override
  _SubjectRowState createState() => _SubjectRowState();
}

class _SubjectRowState extends State<SubjectRow> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {

    String subjectName = widget.subject.split('.')[1].trim();
    String subjectCode = widget.subject.split('.')[0].trim();

    final baseTextStyle = const TextStyle(
        fontFamily: 'Poppins'
    );
    final regularTextStyle = baseTextStyle.copyWith(
        color: const Color(0xffb6b2df),
        fontSize: 9.0,
        fontWeight: FontWeight.w400
    );
    final subHeaderTextStyle = regularTextStyle.copyWith(
        color: selected ? Colors.white : const Color(0xffa7a9ac),
        fontSize: 12.0,
        fontWeight: FontWeight.w400
    );
    final headerTextStyle = baseTextStyle.copyWith(
        color: selected ?  Colors.white : const Color(0xFF86a2ea),
        fontSize: 18.0,
        fontWeight: FontWeight.w600
    );

    final subjectCardContent =  Container(
      margin:  EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 13.0),
      //constraints:  BoxConstraints.expand(),
      child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Container(height: 2.0),

              Text(subjectName,overflow: TextOverflow.ellipsis ,style: headerTextStyle,),



              Container(height: 3.0),

              Text(subjectCode, overflow: TextOverflow.ellipsis ,style: subHeaderTextStyle),


            ],
          ),

    );

  final subjectCard = GestureDetector(
     onTap: (){

       setState(() {
         selected = !selected;

       });


     },
     child: Container(
    child: subjectCardContent,
    height: 90.0,
    //margin: EdgeInsets.only(left: 46.0),
    decoration: BoxDecoration(
        color: selected ? Color(0xFF86a2ea) : Colors.white  ,
        shape: BoxShape.rectangle,
        border: Border.all(color:  Color(0xFF86a2ea), width: 2),
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


       return  Container(
             height: 80.0,
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





