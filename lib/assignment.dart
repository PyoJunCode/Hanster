import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as Dom;
import 'as_notice.dart';
import 'assignmentAndNotification.dart';

class assign extends StatefulWidget {

  final FirebaseUser user;

  assign(this.user);


  @override
  _assignState createState() => _assignState();
}

class _assignState extends State<assign> {

  String selectedClass  ;
  bool loading = true;
  List<Dom.Element> links = [];
  List<String> parseLinks = [];

  @override

  void initState(){

    super.initState();
  }
  Widget build(BuildContext context) {

    return  buildbody();

  }

  buildbody()  {

    TextStyle label = new TextStyle(
        fontWeight: FontWeight.w900
    );

    if(parseLinks.length != 0) setState(() {
      loading = false;
    });
    return   DefaultTabController(

      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: new Color(0xffB7C2F3),
          //elevation: 0.0,
          centerTitle: true,
          leading:
          new IconButton(
            icon: Icon(Icons.arrow_back_ios,color: Colors.white,size: 33.0,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(padding: const EdgeInsets.only(top:16.0),),
              Image.asset('assets/images/assignment_image.png', height: 35,),
            ],
          ),
          actions:

          <Widget>[
            PopupMenuButton(

              icon: Icon(Icons.menu,color: Colors.white,size: 37.0,),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text("QnA"),
                ),
                PopupMenuItem(
                  child: Text("스터디모집 "),
                ),
                PopupMenuItem(
                  child: Text("과제관리 "),
                ),
              ],
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width*1.0,
                  height: MediaQuery.of(context).size.height*0.07,
                  color: Colors.white,
                ),
                Stack(

                    children: <Widget> [
                      Container(
                        alignment: Alignment(0.0, 0.0),
                        width: MediaQuery.of(context).size.width*1.0,
                        height: MediaQuery.of(context).size.height*0.07,
                        child: Container(
                          width: 1.7,
                          height: MediaQuery.of(context).size.height*0.05 ,
                          color: Color(0xffBCBEB0),
                        ),
                      ),

                      Container(
                        child: TabBar(
                          indicator: CircleTabIndicator(color: Color(0xfff9BE06), radius: 4),
                          labelColor: Color(0xfff9BE06),
                          labelStyle: label,
                          unselectedLabelStyle: label,
                          unselectedLabelColor:  Color(0xff414042),
                          tabs: [
                            new Tab(text:"과제공지 "),
                            new Tab(text:"과제제출현황 "),
                          ],
                        ),
                      ),

                    ]
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            assignment_notice(widget.user), //과제 공
            assignment_submit(widget.user), //제출 현황
          ],
        ),),
    );
  }



}


class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({@required Color color, @required double radius}) : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
    ..color = color
    ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset = offset + Offset(cfg.size.width / 2, cfg.size.height - radius-5);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}