import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

class PostDetails extends StatefulWidget {
  final String name;
  final String title;
  final String body;
  const PostDetails(
      {Key? key, required this.name, required this.title, required this.body})
      : super(key: key);

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  List<dynamic> postDetails = [];

  @override
  void initState() {
    // TODO: implement initState
    fetchPostDetails();
    super.initState();
  }

  void fetchPostDetails() async {
    var response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/1/comments'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(jsonData);
      setState(() {
        postDetails = jsonData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Post Details'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 250,
              child: Card(
                child: ListTile(
                  title: Text(
                    widget.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                  subtitle: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(fontSize: 20, color: Colors.black87),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          widget.body,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Comments',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            ),

            //Comments on the posts
            Expanded(
              child: ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: postDetails.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 150,
                    color: Colors.grey.withOpacity(0.1),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      // leading: Text(postDetails[index]['id']),
                      title: Text(
                        postDetails[index]['name'],
                        style: const TextStyle(color: Colors.black87),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            postDetails[index]['email'],
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black45),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Html(
                            data: postDetails[index]['body'],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }
}
