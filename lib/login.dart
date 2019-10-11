import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hanster_app/checkID.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';




// ignore: camel_case_types
class loginPage extends StatefulWidget {

  @override
  _loginPageState createState() => _loginPageState();
}

// ignore: camel_case_types
class _loginPageState extends State<loginPage> {

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final textEditingController = TextEditingController();

  bool loading = false;

  @override
  void dispose(){
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfdbad0),
      body: buildBody(),
    );
  }

  buildBody(){

    String mail;

    return ModalProgressHUD(
      child: Center(child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding: const EdgeInsets.all(90)),

            Text('언제까지 공부, 혼자 할래?', style: TextStyle(fontSize: 26,
                fontWeight: FontWeight.bold,color: const Color(0xFFffffff))),
            Padding(padding: const EdgeInsets.all(7)),

            Container(
              width: 280,
              height: 130,
              color: const Color(0xFFffffff),
              child: Text(
                  '한스', textAlign: TextAlign.center,style: TextStyle(fontSize: 88,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFfdbad0))
              ),
            ),

            Padding(padding: const EdgeInsets.all(5)),
            Text('한   동   에   서   의   공  부   추   구', style: TextStyle(fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFffffff)),),

            Padding(padding: const EdgeInsets.all(60)),

            Center(
              child: new IconButton(
                icon: Icon(Icons.power_settings_new,
                  size: 40,
                  color: const Color(0xFFffffff),),

                onPressed: () {

                  setState(() {
                    loading = true;

                  });

                  SignInMathod().then((user) {
                    mail= user.email.split('@')[1];

                    if(mail == 'handong.edu') {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => checkPage(user)));
                    }
                    else{
                      handong(context);
                      FirebaseAuth.instance.signOut();
                      googleSignIn.signOut();
                    }
                  });
                },
              ),
            ),
            Padding(padding: const EdgeInsets.all(17)),
            Text('이젠 네가 시작해봐!', style: TextStyle(fontSize: 15,
                fontWeight: FontWeight.bold,color: const Color(0xFFffffff))),
          ],
        ),
      )
      ),
    inAsyncCall: loading,);

  }

  Future<FirebaseUser> SignInMathod() async {
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    FirebaseUser user = (await auth.signInWithCredential(
        GoogleAuthProvider.getCredential(idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken))).user;

    loading = false;

    return user;
  }

}

void handong(BuildContext context){
  var alert = AlertDialog(
    title: Text('오류'),
    content: Text('한동대 메일로 로그인 해주세요'),
  );

  showDialog(context: context,builder: (BuildContext context){
    return alert;
  }
  );
}

