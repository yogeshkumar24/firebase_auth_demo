import 'dart:convert';

import 'package:auth_demo/MyDrawer/my_drawer.dart';
import 'package:auth_demo/Post/Model/post.dart';

import 'package:auth_demo/PostsDetails/Model/post_details_comments.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';


class PostsDetails extends StatefulWidget {
  static String routeName = "PostsDetails";
  @override
  _PostsDetailsState createState() => _PostsDetailsState();
}



class _PostsDetailsState extends State<PostsDetails> {


  late List<PostDetailComments> postDetailList;
     Post? post;

  @override
  void initState() {
    postDetailList = <PostDetailComments>[];

    super.initState();
  }

  getArgs() {
    print("Called ===============");
     post = ModalRoute
        .of(context)
        ?.settings
        .arguments as Post;

    postsDetailsComments().then((value) {
      setState(() {
        postDetailList = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    if(post==null){
      getArgs();
    }
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(title: Text("Post Details"),),
      body: Column(
        children: [
       Container(
          width:double.infinity,
          height: MediaQuery
            .of(context)
            .size
            .height / 4, color: Colors.blue,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
             post == null?Container():Text(
                post?.title??"", style: TextStyle(color: Colors.white, fontSize: 16),),
              SizedBox(height: 12,),
              Text(
                post?.body??"", style: TextStyle(color: Colors.white, fontSize: 12),),
            ],),),
           Expanded(
          child:isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.blue,),)
              : ListView.builder(
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


  Future<List<PostDetailComments>> postsDetailsComments() async {
    setState(() {
      isLoading = true;
    });
    var id = post?.id??"1";
    print("id is$id");
    print(post?.title);
    Response response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/comments?postId=$id'),
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
