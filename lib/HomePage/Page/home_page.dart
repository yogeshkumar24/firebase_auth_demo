import 'dart:async';
import 'dart:convert';
import 'package:auth_demo/HomePage/Model/demo_model.dart';
import 'package:auth_demo/MyDrawer/my_drawer.dart';
import 'package:auth_demo/Post/Model/post.dart';
import 'package:auth_demo/PostsDetails/Page/posts_details.dart';
import 'package:auth_demo/Services/post_services.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart'as http;
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
     static String routeName  = "HomePage";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  GoogleSignIn googleSignIn  =  GoogleSignIn();
  late List<DemoModel> modelList;
  late Post post;

  @override
  void initState() {
    modelList = <DemoModel>[];
    fetchAlbum().then((value) {
      setState(() {
        modelList = value;
      });
    });

    initDynamicLinks();
    super.initState();
  }


  void initDynamicLinks() async {

    post = Post();
    post.body= "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium";
    post.title ="sunt aut facere repellat provident occaecati excepturi optio reprehenderit";
    PostService().init();
    List<Post> postList = PostService().postList;
    print("=========================${postList.length}");
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (dynamicLink) async {
          final Uri? deepLink = dynamicLink?.link;
          print(deepLink);
          if (deepLink != null) {
            bool  isPostPage = deepLink.path == "/postPage.com";
            print(deepLink);
            if(isPostPage){
              setState(() {
                print("postPage");
                Navigator.of(context).pushNamed(PostsDetails.routeName,arguments: postList== null || postList.isEmpty ?post:postList[4]);
              });

            }else{
              print("homepage");
              Navigator.pushNamed(context, HomePage.routeName);

            }
          }
        },
        onError: (OnLinkErrorException e) async {
          print('onLinkError');
          print(e.message);
        }
    );

    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      bool  isPostPage = deepLink.path == "/postPage.com";
      print(deepLink);
      if(isPostPage){
        setState(() {
          Navigator.of(context).pushNamed(PostsDetails.routeName,arguments: postList.isEmpty || postList == null ?post:postList[4]);
        });
        print("postPage");
      }else{
        Navigator.pushNamed(context, HomePage.routeName,);
        print("homepage");
      }
    }
  }



  Widget build(BuildContext context) {

    return Scaffold(
        drawer: MyDrawer(),
      appBar: AppBar(title: Text("Home Page"),
    ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading?Center(child: CircularProgressIndicator(),):ListView.builder(scrollDirection: Axis.vertical,
            itemCount: modelList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
          return Card(elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            margin: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,children: [
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.all(10),
                  child: Text("${modelList[index].title}")),
            SizedBox(height: 10,),
            CachedNetworkImage(
              imageUrl: "${modelList[index].url}",
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ],),);
            }),
      )
      );
  }


  Future<List<DemoModel>> fetchAlbum() async {
  setState(() {
    isLoading = true;
  });
    final response =
    await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
  setState(() {
    isLoading = false;
  });

    if (response.statusCode == 200) {
     return (json.decode(response.body) as List).map((i) =>
          DemoModel.fromJson(i)).toList();

    } else {
      return [];
    }
  }
}
