import 'package:auth_demo/Post/Page/post_page.dart';
import 'package:auth_demo/SignIn/Page/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  var name;
  var email;
bool isLoading = false;

  getData()async{
    setState(() {
      isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var isLogin = await  GoogleSignIn().isSignedIn();
    if(isLogin){
      setState(() {
        name = sharedPreferences.getString("name");
        email = sharedPreferences.getString("email");
        isLoading = false;
      });
    }
    else{
    FacebookAuth.instance.getUserData().then((userData) {
      Map map  = userData;
      print("here is youe fn name ${map["name"]}");
      if(map.isNotEmpty){
        setState(() {
          name = map["name"];
          email = map["email"];
          isLoading = false;
        });
        print(email);
      }
    });}
  }

  didChangeDependencies(){

    getData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text('Welcome',style: TextStyle(fontSize: 28,color: Colors.white),),
                  SizedBox(
                    height: 10,
                  ),
                 isLoading ? Center(child: CircularProgressIndicator(),):Text("$name",style: TextStyle(fontSize: 16,color: Colors.white),),
                  SizedBox(height: 10,),
                  isLoading ? Center(child: CircularProgressIndicator(),):Text("$email",style: TextStyle(fontSize: 12,color: Colors.white),),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text('Posts'),
              onTap: () {
                Navigator.of(context).pushNamed(PostPage.routeName);
              },
            ),
           Padding(
             padding: const EdgeInsets.only(left: 12,right: 12),
             child: Container(height: 0.50,color: Colors.blue,),
           ),
            ListTile(
              leading: Icon(Icons.account_circle),

              title: Text("Logout"),
              subtitle: Text("($name)",style: TextStyle(fontSize: 8,color: Colors.blue),),
              onTap: (){
                showDialog(context: context, builder: (BuildContext context){
                  return AlertDialog(
                    title: Text("Logout"),
                    content: Text("Do you want to logout?"),
                    actions: [ FlatButton(onPressed: (){
                      Navigator.of(context).pop();
                    },child: Text("No"),),
                      FlatButton(onPressed: (){
                        signOut();
                      },child: Text("Yes"),),
                    ],
                  );
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12,right: 12),
              child: Container(height: 0.50,color: Colors.blue,),
            ),
          ],
        ),
      ),),
    );
  }

  signOut() async {
    var isLogin = await  GoogleSignIn().isSignedIn();
    if(isLogin){
      GoogleSignIn().signOut();
      await onLogout();
    }else{
      await FacebookAuth.instance.logOut();
      await onLogout();
    }

  }

  Future<void> onLogout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isLogin", false);
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(SignInPage.routeName,);
  }
}
