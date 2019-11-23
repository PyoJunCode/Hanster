import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class Start extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
       Scaffold(
         backgroundColor: Color(0XFFB7C2F3),
         body: Stack(
           alignment: Alignment.center,
           children: <Widget>[
             Image.asset('image/Startlogo.png', fit: BoxFit.fill,),
           ],
         ),
       );

  }
}
