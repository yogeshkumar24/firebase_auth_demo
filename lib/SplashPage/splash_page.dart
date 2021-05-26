import 'dart:async';

import 'package:auth_demo/HomePage/Page/home_page.dart';
import 'package:auth_demo/SignIn/Page/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {


  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isLogin = false;

  @override
  void initState() {
     isLoginMethod();
    Timer(
        Duration(seconds: 3),
            (){
              isLogin?Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => HomePage())):
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => SignInPage()));
            });
    super.initState();
  }

  Future isLoginMethod()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isLogin =  sharedPreferences.getBool("isLogin")!;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Welcome"),),
    );
  }
}

