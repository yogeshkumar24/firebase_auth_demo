import 'dart:convert';
import 'package:auth_demo/MyDrawer/my_drawer.dart';
import 'package:auth_demo/Post/post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
class PostPage extends StatefulWidget {

  static String routeName = "PostPage";
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool isLoading = false;
late List<Post> postList;
  @override
  void initState() {
    postList = <Post>[];
        posts().then((value) {


              postList = value;
        print(postList.length);
        });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(title: Text("All Post"),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading == true?Center(child: CircularProgressIndicator(),):ListView.builder(scrollDirection: Axis.vertical,
            itemCount: postList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(padding: EdgeInsets.all(10),
                  child: Card(elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: EdgeInsets.all(10),child: Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(children: [  Text("Id",style: TextStyle(fontSize: 16,color: Colors.blue),),
                            SizedBox(width: 10,),
                            Text("${postList[index].id}"),],),

                        SizedBox(height: 10,),
                        Text("Title",style: TextStyle(fontSize: 16,color: Colors.blue),),
                        Text("${postList[index].title}"),
                        SizedBox(height: 10,),
                          Text("Body",style: TextStyle(fontSize: 16,color: Colors.blue),),
                        Text("${postList[index].body}"),
                        SizedBox(height: 10,),
                      ],),
                    ),));
            }),
      ),
    );
  }


   Future<List<Post>> posts()async {
     setState(() {
       isLoading = true;
     });
     Response response = await http.get(
       Uri.parse('https://jsonplaceholder.typicode.com/posts'),
     );
     setState(() {
       isLoading = false;
     });
     if (response.statusCode == 200) {
       return (json.decode(response.body) as List).map((i) =>
           Post.fromJson(i)).toList();
     } else {
       return [];
     }
   }
  }

