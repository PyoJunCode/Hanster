import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hanster_app/login.dart';
import 'package:hanster_app/qnaSubject.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

//입장하기, 로그아웃 페이지

class checkPage extends StatelessWidget {

  final FirebaseUser user;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool first = true;
  bool loading = false;

  checkPage(this.user);

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      child: Scaffold(
        //backgroundColor: const Color(0xFFfcf3f6),
          appBar: AppBar(
              centerTitle: true,
              title: Text('Welcome',style: TextStyle(fontSize: 20, color: Colors.grey),)
          ),

          /*
        * Text('HMC', style: TextStyle(fontSize: 100,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFff76b9)),),
              */

          body: Padding(padding: EdgeInsets.all(63),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('안녕하세요', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: const Color(0xFFfd9dbd)),),
                    Padding(padding: const EdgeInsets.all(3)),
                    Text('한만추에 오신 것을 환영합니다.', style: TextStyle(fontSize: 20, color: Colors.grey),),
                    Padding(padding: const EdgeInsets.all(12)),
                    SizedBox(
                      width: 230,
                      height: 230,
                      child: Card(
                        elevation: 4.0,
                        child: Padding(padding: EdgeInsets.all(8),
                          child: Column(
                              children: <Widget>[
                                Padding(padding: EdgeInsets.all(20)),
                                SizedBox(
                                  width: 90,
                                  height: 90,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(user.photoUrl),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(10),),
                                Text(user.displayName+' 님',
                                    style: TextStyle(fontSize: 20)),
                              ]
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(17),),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(onPressed: (){

                            loading = true;

                            checkAuth();

                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => qnaSubjectPage(user)));

//              if(first == false) {
//                Navigator.pushReplacement(context, MaterialPageRoute(
//                    builder: (context) => frontPage(user)));
//              }else{
//                Navigator.pushReplacement(context, MaterialPageRoute(
//                    builder: (context) => MyApp(user)));
//              }


                          }, color: const Color(0xFFf9c8d9),
                            child: Text('입장하기', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: const Color(0xFFffffff)),),
                          ),
                          Padding(padding: EdgeInsets.all(3)),
                          RaisedButton(onPressed: () {
                            FirebaseAuth.instance.signOut();
                            googleSignIn.signOut();
                            Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (context) => loginPage()));

                          },
                            color: const Color(0xFFf9c8d9),
                            child: Text('로그아웃', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: const Color(0xFFffffff)),),)
                        ]
                    ),
                  ],
                ),
              ),
            ),)
      ),
    inAsyncCall: loading,);
  }

  Future<Null> checkAuth() async {

    if(user != null){ //처음오는게 아니면 documents로 가져온다.

      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where(user.email.split('@')[0])
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;


      if(documents.length == 0){
        print('new auth');
        print('setData');// 길이가 0이면 기본세팅
        Firestore.instance.collection('users').document(user.email.split('@')[0]).setData({
          'hakbun' : user.email.split('@')[0],
          'name' : user.displayName,
          'gender' : 'male'
        });

        first = false;
      }
      first = false;

    }

    else first = true;

    loading = false;

  }
}
