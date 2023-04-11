import 'package:flutter/material.dart';
import 'package:flutter_crud_api/screens/single_post_screen.dart';

import '../api_service.dart';
import '../models/post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // key: _formKey,
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  bool _isLoading = true;
  List<Post> _posts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchPosts();
  }

  _fetchPosts() async {
    setState(() {
      _isLoading = true;
    });
    final posts = await ApiService.getPosts();
    setState(() {
      _posts = posts;
      _isLoading = false;
    });
  }

  void clear() {
    _titleController.clear();
    _bodyController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Demo'),
        actions: [
          IconButton(
              onPressed: () {
                _fetchPosts();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (ctx, ind) {
                return ListTile(
                  title: Text(_posts[ind].title),
                  subtitle: Text(_posts[ind].body),
                  leading: const Icon(Icons.work),
                  trailing: Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: () {
                           AddorUpdatePost(context, true, _posts[ind]);
                        }, icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      title: const Text("Confirm Delete"),
                                      content: Text(
                                          "Do you want to delete ${_posts[ind].title}?"),
                                      actions: [
                                        TextButton(
                                          child: const Text("Cancel"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        TextButton(
                                          child: const Text("Delete"),
                                          onPressed: () {
                                            ApiService.deletePost(
                                                _posts[ind].id);
                                            setState(() {
                                              _posts.removeAt(ind);
                                            });
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    );
                                  });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ))
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SinglePostScreen(_posts[ind].id)),
                    );
                  },
                );
              }),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            // Create show dialog with form
            AddorUpdatePost(context, false, null);
          }),
    );
  }

  Future<dynamic> AddorUpdatePost(
      BuildContext context, bool isUpdate, Post? post) {
        clear();
    if (isUpdate) {
      _titleController.text = post!.title;
      _bodyController.text = post.body;
    }
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: isUpdate ? const Text("Update Post") : const Text("Create Post"),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: "Title"),
                    validator: (value) =>
                        value!.isEmpty ? "Title is required" : null,
                  ),
                  TextFormField(
                    controller: _bodyController,
                    decoration: const InputDecoration(
                      labelText: "Body",
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Body is required" : null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // id doesnot have any work
                        if(isUpdate){
                            Post updatedPost = await ApiService.updatePost(
                              Post(
                                title: _titleController.text,
                                body: _bodyController.text,
                                userId: 1,
                                id: post!.id
                              )
                            );
                            setState(() {
                              _posts[_posts.indexWhere((element) => element.id == post.id)] = updatedPost;
                            });

                        }else{
                            Post post = Post(
                              title: _titleController.text,
                              body: _bodyController.text,
                              userId: 1,
                              id: 1);
                          Post data = await ApiService.createPost(post);
                          setState(() {
                            _posts.add(data);
                          });
                        }
                          clear();
                          Navigator.pop(context);
                        }
                      },
                      child: isUpdate ? const Text("Update") : const Text("Create"))
                ],
              ),
            ),
          );
        });
  }
}
