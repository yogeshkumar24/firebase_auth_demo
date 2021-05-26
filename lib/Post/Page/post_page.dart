import 'dart:convert';
import 'package:auth_demo/MyDrawer/my_drawer.dart';
import 'package:auth_demo/Post/Model/post.dart';
import 'package:auth_demo/PostsDetails/Page/posts_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
class PostPage extends StatefulWidget {

  static String routeName = "PostPage";
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
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
      appBar: AppBar(title: Text("All Post"),
      actions: [
        InkWell(
            onTap: (){
              buildShowDialog(context);
            },
            child: Icon(Icons.add)),
        SizedBox(
          width: 12,
        ),
      ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading == true?Center(child: CircularProgressIndicator(),):ListView.builder(scrollDirection: Axis.vertical,
            itemCount: postList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  int? id = postList[index].id;

                  print("index is  ====================${postList[index].id}");

                  Navigator.of(context).pushNamed(PostsDetails.routeName,arguments:{"index":id});
                },
                child: Padding(padding: EdgeInsets.all(10),
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
                              Text("${postList[index].id}"),
                            Expanded(child: InkWell(
                                onTap: (){
                                  buildShowDialog(context);
                                },
                                child: Icon(Icons.edit)))],),
                          
                          SizedBox(height: 10,),
                          Text("Title",style: TextStyle(fontSize: 16,color: Colors.blue),),
                          Text("${postList[index].title}"),
                          SizedBox(height: 10,),
                            Text("Body",style: TextStyle(fontSize: 16,color: Colors.blue),),
                          Text("${postList[index].body}"),
                          SizedBox(height: 10,),
                        ],),
                      ),)),
              );
            }),
      ),
    );
  }

  buildShowDialog(BuildContext context) {
    return showDialog(context: context, builder: (BuildContext context){
              return Container(
                  height: 300,
                  child: AlertDialog(title:Text("Add Post"),
                  actions: [
                    buildTextField("Enter title",titleController),
                    SizedBox(height: 12,),
                    buildTextField("Enter body",bodyController),
                    SizedBox(height: 12,),

                    MaterialButton(onPressed: ()async{
                      await addPost(titleController.text, bodyController.text);
                        setState(() {
                       posts();
                        });
                    },
                    child: Text("Save"),)
                  ],));
            });
  }

  TextField buildTextField(String hintText,TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),);
  }




  Future addPost(title,body)async {
    setState(() {
      isLoading = true;
    });

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
    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 201) {
       return json.decode(response.body);
    }
    return [];
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

