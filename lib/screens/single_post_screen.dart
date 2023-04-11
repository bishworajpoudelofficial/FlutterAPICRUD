import 'package:flutter/material.dart';

import '../api_service.dart';
import '../models/post.dart';

class SinglePostScreen extends StatefulWidget {
  int id;
  SinglePostScreen(this.id, {super.key});

  @override
  State<SinglePostScreen> createState() => _SinglePostScreenState();
}

class _SinglePostScreenState extends State<SinglePostScreen> {
  bool _isLoading = true;
  late Post _post;

  @override
  void initState() {
    super.initState();
    _fetchPost();
  }

  _fetchPost() async{
    setState(() {
      _isLoading = true;
    });
    final post = await ApiService.getPost(widget.id);
    setState(() {
        _post = post;
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: _isLoading ? const Text("Loading") : Text(_post.title),
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator()):  Column(
       
        children: [
          Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_post.body, style: const TextStyle(fontSize: 22),),
              ),
            ),
          )
        ],
      ),
    );
  }
}