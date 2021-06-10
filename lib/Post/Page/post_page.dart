import 'dart:convert';
import 'package:auth_demo/MyDrawer/my_drawer.dart';
import 'package:auth_demo/Post/Model/post.dart';
import 'package:auth_demo/Post/ViewModel/post_page_viewmodel.dart';
import 'package:auth_demo/PostsDetails/Page/posts_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
class PostPage extends StatefulWidget {

  static String routeName = "PostPage";
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  PostPageViewModel viewModel =  PostPageViewModel();

  bool isLoading = false;
  late List<Post> postList;
   bool isDynamic=  false;
  @override
  void initState() {
    postList = <Post>[];
  getPosts().then((value) {
    postList = value;
  });
    super.initState();

  }


  @override
  Widget build(BuildContext context) {

    return ScopedModel<PostPageViewModel>(
      model: viewModel,
      child: ScopedModelDescendant<PostPageViewModel>(
        builder: (context,model, child){
          return  Scaffold(
            drawer: MyDrawer(),
            appBar: AppBar(title: Text("All Post"),
              actions: [
                InkWell(
                    onTap: (){
                      buildShowDialog(context,()async{
                        addPost(titleController.text, bodyController.text).then((value) {
                          setState(() {
                            postList.add(value);
                          });
                          clearTextField();
                        });
                        Navigator.of(context).pop();
                      });
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
                        Navigator.of(context).pushNamed(PostsDetails.routeName,arguments:postList[index]);
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
                                  Row(mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                          onTap: (){
                                            titleController.text = postList[index].title??"";
                                            bodyController.text = postList[index].body??"";
                                            showDialog(context: context, builder: (BuildContext context){
                                              return Container(
                                                  height: 300,
                                                  child: AlertDialog(title:Text("Edit Post"),
                                                    actions: [
                                                      post== null?buildTextField("Enter title",titleController):buildTextField("Enter title",titleController),
                                                      SizedBox(height: 12,),
                                                      buildTextField("Enter body",bodyController),
                                                      SizedBox(height: 12,),

                                                      MaterialButton(onPressed: ()async{
                                                     Post post  =await editPost(titleController.text, bodyController.text, postList[index].id,postList[index].userId);

                                                     Post oldPost = postList.firstWhere((element) => element.id == post.id);

                                                     setState(() {
                                                       oldPost.title = post.title;
                                                       oldPost.body = post.body;
                                                     });
                                                     clearTextField();
                                                        Navigator.of(context).pop();

                                                      },
                                                        child: Text("Edit"),)
                                                    ],));
                                            });
                                          },
                                          child: Icon(Icons.edit)),
                                      SizedBox()],),

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
        },

      ),
    );
  }

  buildShowDialog(BuildContext context,onPressed) {

    return showDialog(context: context, builder: (BuildContext context){
              return Container(
                  height: 300,
                  child: AlertDialog(title:Text("Add Post"),
                  actions: [
                    buildTextField("Enter title",titleController),
                    SizedBox(height: 12,),
                    buildTextField("Enter body",bodyController),
                    SizedBox(height: 12,),

                    MaterialButton(onPressed: onPressed,
                    child: Text("Save"),)
                  ],));
            });
  }

  clearTextField(){
    titleController.text = "";
    bodyController.text = "";
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


  Future<Post> editPost(title,body,id,userId)async {
    setState(() {
      isLoading = true;
    });

    Response response = await http.put(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'),
      body: jsonEncode(<dynamic, dynamic>{
        "id":id,
        'title': title,
        "body": body,
        "userId": userId,
      }),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
      },
    );

    setState(() {
      isLoading = false;
    });

    print("edit response staus code = ${response.statusCode}");

    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    }else{
      throw Exception('Failed to edit post');
    }

  }


  Future addPost(title,body)async {
    setState(() {
      isLoading = true;
    });

    Response response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts?userId=1'),
      body: jsonEncode(<dynamic, dynamic>{
        'title': title,
        "body": body,
      }),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
      },
    );
    setState(() {
      isLoading = false;
    });
    json.decode(response.body);
    print(response.statusCode);
    if (response.statusCode == 201) {
       return Post.fromJson(json.decode(response.body));
    }
    return Post.fromJson(json.decode(response.body));
  }

   // Future<List<Post>> getPosts()async {
   //   setState(() {
   //     isLoading = true;
   //   });
   //   Response response = await http.get(
   //     Uri.parse('https://jsonplaceholder.typicode.com/posts'),
   //   );
   //
   //   print(response.statusCode);
   //   setState(() {
   //     isLoading = false;
   //   });
   //   if (response.statusCode == 200) {
   //     return (json.decode(response.body) as List).map((i) =>
   //         Post.fromJson(i)).toList();
   //   } else {
   //     return [];
   //   }
   // }

  Future<List<Post>> getPosts()async {
    setState(() {
      isLoading = true;
    });
    postList = <Post>[];

    Response response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts?userId=1'),
    );

    setState(() {
      isLoading = false;
    });
    postList =  (json.decode(response.body) as List).map((i) =>
        Post.fromJson(i)).toList();

    return postList;
  }
  }

