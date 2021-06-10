import 'dart:convert';

import 'package:auth_demo/Post/Model/post.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class PostService {

  PostService._privateConstructor();

  static final PostService _instance = PostService._privateConstructor();

  List<Post> postList = [];

  factory PostService() {
    return _instance;
  }

  init()async{
    postList = await getPosts();
  }

  Future<List<Post>> getPosts()async {



    Response response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts?userId=1'),
    );

    postList =  (json.decode(response.body) as List).map((i) =>
        Post.fromJson(i)).toList();

    return postList;
  }

}