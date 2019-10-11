import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hanster_app/front.dart';
import 'package:hanster_app/login.dart';

import 'checkID.dart';


class rootPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData) {
          return frontPage(snapshot.data);
        }else{
          return loginPage();
        }
      },

    );

  }
}
