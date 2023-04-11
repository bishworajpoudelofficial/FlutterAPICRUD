import 'package:http/http.dart' as http;

import 'models/post.dart';
class ApiService{
  // Url of the API
  static const String BASE_URL = "https://jsonplaceholder.typicode.com/posts";

  // Get all posts
  static Future<List<Post>> getPosts() async {
    try {
      final response = await http.get(Uri.parse(BASE_URL));
      if (response.statusCode == 200) {
        List<Post> list = postFromJson(response.body);
        return list;
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Get single post
  static Future<Post> getPost(int id) async {
    try {
      final response = await http.get(Uri.parse(BASE_URL + "/$id"));
      if (response.statusCode == 200) {
        Post post = singlepostFromJson(response.body);
        return post;
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  // Post Request
  static Future<Post> createPost(Post post) async {
    try {
      final response = await http.post(
        Uri.parse(BASE_URL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: singlepostToJson(post),
      );
      if (response.statusCode == 201) {
        Post post = singlepostFromJson(response.body);
        return post;
      } else {
        throw Exception('Failed to create post.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  // Update Request
  static Future<Post> updatePost(Post post) async {
    try {
      final response = await http.put(
        Uri.parse(BASE_URL + "/${post.id}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: singlepostToJson(post),
      );
      if (response.statusCode == 200) {
        Post post = singlepostFromJson(response.body);
        return post;
      } else {
        throw Exception('Failed to update post.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  // Delete Request
  static Future<void> deletePost(int id) async {
    try {
      final response = await http.delete(
        Uri.parse(BASE_URL + "/$id"),
      );
      if (response.statusCode == 200) {
        print("Post Deleted");
      } else {
        throw Exception('Failed to delete post.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  

}