import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hanster_app/qna.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';



class frontPage extends StatefulWidget {

  final FirebaseUser user;

  frontPage(this.user);


  @override
  _frontPageState createState() => _frontPageState();
}

class _frontPageState extends State<frontPage> {
  int menu_select = 0;

  List pages;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pages = [

      qnaPage()

    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: pages[menu_select],
      bottomNavigationBar: BottomNavigationBar(
          onTap: changeMenu,
          currentIndex: menu_select,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.question_answer), title: Text('QnA')),
            BottomNavigationBarItem(icon: Icon(Icons.signal_wifi_4_bar), title: Text('Signal')),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle), title: Text('My Info')),
          ]),
    );
  }

  void changeMenu(int menu_index) {
    setState(() {
      menu_select = menu_index;
    });
  }


}
