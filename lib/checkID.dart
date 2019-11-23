import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hanster_app/login.dart';
import 'package:hanster_app/menu.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class checkPage extends StatelessWidget {

  final FirebaseUser user;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool loading = false;

  checkPage(this.user);

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      child: Scaffold(

          backgroundColor: const  Color(0xFFADB7F0),



          body: Padding(padding: EdgeInsets.all(63),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(50),),
                    Padding(padding: EdgeInsets.all(3),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(padding: EdgeInsets.all(20)),
                                SizedBox(
                                  width: 90,
                                  height: 90,
                                  child: Container(
                                    child: Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: 42.0,
                                          backgroundColor: Colors.white,
                                        ),
                                        CircleAvatar(
                                          radius: 40.0,
                                          backgroundImage: NetworkImage(user.photoUrl),
                                        ),
                                        Container(
                                            alignment: Alignment.topRight,
                                            child: Image.asset('assets/images/book.png')),
                                      ],
                                    )
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(10),),
                                Text('안녕하세요', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color:Colors.white),),
                                Padding(padding: EdgeInsets.only(top: 10),),
                                Text(user.displayName+' 님!',
                                    style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.w800), ),
                              ]
                          ),
                        ),


                    Padding(padding: EdgeInsets.all(17),),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){
                              loading = true;
                              checkAuth();
                              Navigator.pushReplacement(context, MaterialPageRoute(
                                  builder: (context) => menuPage(user)));
                            },
                            child: Container(

                              width: 300,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color:  Color(0xFFFFFFFF)  ,
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color:  Color(0xFFFFFFFF), width: 2),
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 3.0,
                                      offset: Offset(0.0, 5.0),
                                    )
                                  ]
                              ),
                              child: Text('시작하기', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: const Color(0xFF86a2ea)),),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 15)),

                          GestureDetector(
                            onTap: (){
                              FirebaseAuth.instance.signOut();
                              googleSignIn.signOut();
                              Navigator.pushReplacement(context, MaterialPageRoute(
                                  builder: (context) => loginPage()));
                            },
                            child: Container(

                              width: 300,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color:  Color(0xFF7693E5)  ,
                                  shape: BoxShape.rectangle,
                                  //border: Border.all(color:  Color(0xFFFFFFFF), width: 2),
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10.0,
                                      offset: Offset(0.0, 10.0),
                                    )
                                  ]
                              ),
                              child: Text('로그아웃', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: const Color(0xFFFFFFFF)),),
                            ),
                          ),

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
          .where(user.displayName.split('학')[0])
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;


      if(documents.length == 0){

        Firestore.instance.collection('users').document(user.displayName.split('학')[0]).setData({
          'hakbun' : user.email.split('@')[0],
          'name' : user.displayName.split('학')[0],
          'photoUrl' : user.photoUrl,
        });


      }


    }

    loading = false;

  }
}
