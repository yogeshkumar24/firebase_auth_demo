import 'package:auth_demo/HomePage/Page/home_page.dart';
import 'package:auth_demo/PostsDetails/Page/posts_details.dart';
import 'package:auth_demo/SplashPage/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Post/Page/post_page.dart';
import 'SignIn/Page/sign_in_page.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
      routes: {
           HomePage.routeName :(context) => HomePage(),
           SignInPage.routeName :(context) => SignInPage(),
           PostPage.routeName :(context) => PostPage(),
           PostsDetails.routeName :(context) => PostsDetails(),


      },
    );
  }
}



