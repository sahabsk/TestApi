import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:testapi/postDetails.dart';

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {

 List<dynamic> post = [];
 List<dynamic> author =[];

  @override
  void initState() {
    fetchPost();
    fetchAuthor();
    super.initState();
  }

void fetchPost() async {
 var response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
  if(response.statusCode == 200){
    final jsonData =jsonDecode(response.body);
    setState(() {
      post = jsonData;
    });
  }
}
 void fetchAuthor() async {
   var response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
   if(response.statusCode == 200){
     final jsonData =jsonDecode(response.body);
     setState(() {
       author = jsonData;
     });
   }
 }


 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Of Authors'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: author.length,
        itemBuilder: (context,index){
          final postData = post[index];
          final postId = postData['id'];
          final postTitle = postData['title'];
          final postBody = postData['body'];
          // print(postTitle);
          if(author[index]['id']== postId) {
            return GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>PostDetails(name: author[index]['name'],title: postTitle,body: postBody,)));
            },
            child: Card(
              child: ListTile(
                title: Text(author[index]['name'],style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),),
                subtitle: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(postTitle, style: const TextStyle(fontSize: 18,color: Colors.black87),),
                      const SizedBox(height: 8,),
                      Html(data: postBody,),
                    ],
                  ),
                ),
              ),
            ),
          );
          }
        },
      ),
    );
  }
}

