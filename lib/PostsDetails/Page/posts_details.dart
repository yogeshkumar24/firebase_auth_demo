import 'dart:convert';

import 'package:auth_demo/MyDrawer/my_drawer.dart';
import 'package:auth_demo/PostsDetails/Model/post_details.dart';
import 'package:auth_demo/PostsDetails/Model/post_details_comments.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostsDetails extends StatefulWidget {
  static String routeName = "PostsDetails";
  @override
  _PostsDetailsState createState() => _PostsDetailsState();
}



class _PostsDetailsState extends State<PostsDetails> {

  var id;
  var savedId;
  var title;
  var body;
  late List<PostDetailComments> postDetailList;

  @override
  void initState() {
    postDetailList = <PostDetailComments>[];

    postsDetails().then((value) {
    });

    postsDetailsComments().then((value) {
      setState(() {
        postDetailList = value;
      });
    });

    super.initState();
  }

  getArgs() {
    print("Called ===============");
    Map map = ModalRoute
        .of(context)
        ?.settings
        .arguments as Map;
    id = map["index"];
    print("index came from arge${id}");
  }


  @override
  Widget build(BuildContext context) {
    getArgs();
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(title: Text("Post Details"),),
      body: Column(
        children: [
        isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.white,),)
            : Container(height: MediaQuery
            .of(context)
            .size
            .height / 4, color: Colors.blue,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              Text(
                title, style: TextStyle(color: Colors.white, fontSize: 16),),
              SizedBox(height: 12,),
              Text(
                body, style: TextStyle(color: Colors.white, fontSize: 12),),
            ],),),
        Expanded(
          child: ListView.builder(
              itemCount: postDetailList.length,
              shrinkWrap: true,
              itemBuilder: (context ,index){
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name",style: TextStyle(fontSize: 16,color: Colors.blue),),
                      Text("${postDetailList[index].name}"),
                      SizedBox(height: 10,),
                      Text("Email",style: TextStyle(fontSize: 16,color: Colors.blue),),
                      Text("${postDetailList[index].email}"),
                      SizedBox(height: 10,),
                      Text("Body",style: TextStyle(fontSize: 16,color: Colors.blue),),
                      Text("${postDetailList[index].body}"),
                      SizedBox(height: 10,),
                    ]

                  ),
                ),
              ),
            );
          }),
        ),
      ],),
    );
  }

  bool isLoading = false;

  Future postsDetails() async {
    setState(() {
      isLoading = true;
    });
    Response response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
    );
    setState(() {
      isLoading = false;
    });
    var data = json.decode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      title = data["title"];
      body = data["body"];
    } else {
      print(response.statusCode);
    }
  }

  Future<List<PostDetailComments>> postsDetailsComments() async {
    setState(() {
      isLoading = true;
    });
    Response response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/comments?postId=1'),
    );
    setState(() {
      isLoading = false;
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List).map((i) =>
          PostDetailComments.fromJson(i)).toList();
    } else {
      return [];
    }
  }

}
