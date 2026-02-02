import 'package:flutter/material.dart';
import 'package:flutter_application/model/repository/post_repository.dart';

import 'model/post.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const PostScreen(),
    );
  }
}

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  PostScreenState createState() => PostScreenState();
}

class PostScreenState extends State<PostScreen> {
  final PostRepository _repository = PostRepository();
  late Future<List<Post>> _posts;

  @override
  void initState() {
    super.initState();
    _posts = _repository.fetchPosts();
  }

  void _sendPost() async {
    Post newPost = Post(
      title: "Hello Flutter",
      body: "This is a test post",
      userId: 1,
    );
    try {
      Post createdPost = await _repository.createPost(newPost);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Success! Created Post ID: ${createdPost.id}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error creating post")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Demo API",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: FutureBuilder<List<Post>>(
        future: _posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final post = snapshot.data![index];

                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(14),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            post.body,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _sendPost,
        icon: const Icon(Icons.add),
        label: const Text("Create Post"),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
