import 'dart:convert';

import 'package:auth_demo/Post/Model/post.dart';
import 'package:http/http.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class PostPageViewModel extends Model{

  late List<Post> postList;
  late Post post;



  Future<List<Post>> getPosts()async {
    postList = <Post>[];

    Response response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );

    if(response.statusCode == 200){
      return postList =  (json.decode(response.body) as List).map((i) =>
          Post.fromJson(i)).toList();
    }


   return [];
    }


Future<Post> addPost(title,body)async {

  Response response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    body: jsonEncode(<dynamic, dynamic>{
      'title': title,
      "body": body,
      "userId": 11,
    }),
    headers: {
      'Content-type': 'application/json; charset=UTF-8',
    },
  );

     post  = Post.fromJson(json.decode(response.body));

  return post;

  }
}

