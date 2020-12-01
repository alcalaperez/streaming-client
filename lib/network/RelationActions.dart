import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rec_you/util/SharedPreferences.dart';

class RelationsActions{


  Future followUser(String userToFollow) async {
    Map data = {
      'UserToFollowUnfollow': userToFollow,
    };
    var body = json.encode(data);

    final response = await http.post(
        'https://musicstreaming-backend.azurewebsites.net/api/relations',
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          HttpHeaders.authorizationHeader:
          "Bearer " + await SharedPreferencesHelper.getToken()
        },
        body: body);
    if (response.statusCode == 200) {
      return "User followed";
    } else {
      return "Error in URL";
    }
  }

  Future unfollowUser(String userToUnfollow) async {
    Map data = {
      'UserToFollowUnfollow': userToUnfollow,
    };
    var body = json.encode(data);
    final url = Uri.parse(
        "https://musicstreaming-backend.azurewebsites.net/api/relations");
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
      return "User unfollowed";
    } else {
      print("Error in URL");
    }
  }

}