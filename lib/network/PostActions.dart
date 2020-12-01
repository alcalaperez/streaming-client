import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';
import 'package:rec_you/model/Post.dart';
import 'package:rec_you/util/SharedPreferences.dart';

class PostActions{
  List<Post> posts = List();

  Future getPosts() async {
    final response = await http.get(
      'https://musicstreaming-backend.azurewebsites.net/api/feed',
      headers: {
        HttpHeaders.authorizationHeader:
        "Bearer " + await SharedPreferencesHelper.getToken()
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      posts = (data as List).map((json) {
        return Post.fromJSON(json);
      }).toList();
      return posts;
    } else {
      print("Error in URL");
    }
  }

  getFeed() async {
    List<Post> allPosts = await getPosts();
    return ObservableList.of(allPosts);
  }

  Future removePost(String id) async {
    var data = {
      'ForeignId': id,
    };

    var body = json.encode(data);
    final url =
    Uri.parse("https://musicstreaming-backend.azurewebsites.net/api/posts");
    final request = http.Request("DELETE", url);
    request.headers.addAll(<String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
      HttpHeaders.authorizationHeader:
      "Bearer " + await SharedPreferencesHelper.getToken()
    });
    request.body = body;
    final response = await request.send();

    if (response.statusCode == 200) {
      return "Removed";
    } else {
      print("Error in URL");
    }
  }
}