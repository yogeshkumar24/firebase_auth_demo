import 'package:auth_demo/HomePage/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SignInPage extends StatelessWidget {

  static String routeName = "SignInPage";
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SignInButton(
              Buttons.Google,
              text: "Sign in with Google",
              onPressed: () {
                signInWithGoogle(context);
              },
            ),
            SizedBox(height: 12,),
            SignInButton(
              Buttons.Facebook,
              text: "Sign In with Facebook",
              onPressed: () {
                signInWithFacebook(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  signInWithFacebook(context) async {
    try {
      LoginResult result = await FacebookAuth.instance.login(
          permissions: ["public_profile", "email"]);
      if (result.status == LoginStatus.success) {
        SharedPreferences sharedPreferences = await SharedPreferences
            .getInstance();
        sharedPreferences.setBool("isLogin", true);

        FacebookAuth.instance.getUserData().then((userData) {

            Map map  = userData;
            print("here is youe fn name ${map["name"]}");
            sharedPreferences.setString("fbName",map["name"]);
          });

        Navigator.of(context).popAndPushNamed(HomePage.routeName,);
      }
    }
    catch(error){
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(title: Text("Error"),content: Text(error.toString()),);
      });

  }}

  signInWithGoogle(context)async{
    try {

      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if(googleSignInAccount == null){
         return null;
      } else {
      GoogleSignInAuthentication authentication = await googleSignInAccount
          .authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: authentication.accessToken,
            idToken: authentication.idToken);
        UserCredential user = await auth.signInWithCredential(credential);

        SharedPreferences sharedPreferences = await SharedPreferences
            .getInstance();
        sharedPreferences.setString("name", "${user.user?.displayName}");
        sharedPreferences.setString("email", "${user.user?.email}");

        sharedPreferences.setBool("isLogin", true);
        Navigator.of(context).popAndPushNamed(HomePage.routeName,arguments:{"userinfo":user.user} as Map);
      }
    }catch(error){
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(title: Text("Error"),content: Text("$error"),);
      });
    }
  }

}
