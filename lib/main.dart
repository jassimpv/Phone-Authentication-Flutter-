import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FireBase Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(),
      routes: <String, WidgetBuilder>{
        '/loginpage' : (BuildContext context) => Dash(),
        '/landpage' : (BuildContext context) => LoginPage(),
    }
    );
  }
}
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String phoneNo, smsId, verificationId;

  Future<void> verifyPhone() async{
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId){
      this.verificationId = verId;
    };
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]){
      this.verificationId = verId;
      smsCodeDialoge(context).then((value){
        print('Signed In');
      });
    };
    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential auth){
      print('verified');
    };
    final PhoneVerificationFailed verifyFailed = (AuthException e) {
      print('${e.message}');
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNo,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verifiedSuccess,
      verificationFailed: verifyFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieve,
    );
  }
  Future<bool> smsCodeDialoge(BuildContext context){
    return showDialog(context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text('Enter OTP'),
          content: TextField(
            onChanged: (value)  {
              this.smsId  = value;
            },
          ),
          contentPadding: EdgeInsets.all(10.0),
          actions: <Widget>[
            new FlatButton(
                onPressed: (){
                  FirebaseAuth.instance.currentUser().then((user){
                    if(user != null){
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Dash()),
                      );

                    }
                    else{
                      Navigator.of(context).pop();
                      signIn(smsId);
                    }

                  }
                  );
                },
                child: Text('Done', style: TextStyle( color: Colors.blue),))
          ],
        );
      },
    );
  }

  Future<void> signIn(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
     await FirebaseAuth.instance.signInWithCredential(credential)
        .then((user){
      Navigator.of(context).pushReplacementNamed('/loginpage');
    }).catchError((e){
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Sign In')
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: <Widget>[
          Text('Phone Auth',style: TextStyle(fontSize: 20,color: Colors.blue),),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter your phone number',
              ),
              onChanged: (value){
                this.phoneNo = value;
              },
            ),
          ),
          SizedBox(height: 10.0),
          RaisedButton(
            onPressed: verifyPhone,
            child: Text('Verify', style: TextStyle(color: Colors.white),),
            elevation: 7.0,
            color: Colors.blue,

          )
        ],
      ),
    );
  }
}



/*import 'package:flutter/material.dart';

import 'main3.dart';


void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primaryColor: const Color(0xFF02BB9F),
        primaryColorDark: const Color(0xFF167F67),
        accentColor: const Color(0xFF167F67),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Firebase',
      home:  PhoneAuth(),
    );
  }
}

*/




















/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

void main()=>runApp(MyApp());

class MyApp extends StatelessWidget{
  @override 
  Widget build(BuildContext context){
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String phoneNo;
  String smsCode;
  String verificationId;

  Future<void> verifyPhone() async {

    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId){
        this.verificationId=verId;   
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]){
        this.verificationId=verId;
        smsCodeDialog(context).then((value){
        print('Signed In');
        });
    };

    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential auth) {
      print('verified');
      };

    final PhoneVerificationFailed verifiFailed = (AuthException exception){
      print('${exception.message}');

    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: this.phoneNo,
      codeAutoRetrievalTimeout: autoRetrieve,
      codeSent : smsCodeSent,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verifiedSuccess,
      verificationFailed: verifiFailed,

    );
  }

  Future<bool> smsCodeDialog(BuildContext context){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return new AlertDialog(
          title: Text("Enter the OTP received"),
          content: TextField(
            onChanged: (value){
              smsCode=value;
            },
          ),
          contentPadding: EdgeInsets.all(10.0),
          actions: <Widget>[
            FlatButton(
              child: Text("Verify"),
              onPressed: (){
                FirebaseAuth.instance.currentUser().then((user){
                  if(user != null){
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/homepage');
                  }
                  else {
                    Navigator.of(context).pop();
                    signIn();
                  }                  
              });
              },
            )
          ],

        );
      }
    );
  }

  
  

   signIn() async {
       final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
     FirebaseAuth.instance.signInWithCredential(credential).catchError((error) {
    setState(() {
      print( 'Something has gone wrong, please try later');
    });
  }).then((FirebaseUser user) async {
    setState(() {
      print( 'Authentication successful');
    });
    
  });
   /* final FirebaseUser user = await FirebaseAuth.instance.signInWithCredential(credential);
    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    assert(user.uid == currentUser.uid);*/

   /* FirebaseAuth.instance.signInWithPhoneNumber(
      verificationId: verificationId,
      smsCode: smsCode).then((user){
        Navigator.of(context).pushReplacementNamed('/homepage');
      }).catchError((e){
        print(e);
      });*/

  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PhoneAuth"),
        ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: 'Enter Phone number'),
                onChanged: (value){
                  this.phoneNo=value;
                },
              ),
              SizedBox(height: 10.0,),
              RaisedButton(
                onPressed: verifyPhone,
                child: Text('Verify'),
                textColor: Colors.white,
                elevation: 7.0,
                color: Colors.blue,
              ),

            ],
          ),
        ),



      ),
      
    );
  }
}
*/