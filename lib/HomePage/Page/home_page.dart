import 'dart:convert';
import 'package:auth_demo/HomePage/Model/demo_model.dart';
import 'package:auth_demo/MyDrawer/my_drawer.dart';
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


  @override
  void initState() {
    modelList = <DemoModel>[];
    fetchAlbum().then((value) {
      setState(() {
        modelList = value;
      });
    });


    super.initState();
  }
  @override
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
