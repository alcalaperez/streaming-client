import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rec_you/model/User.dart';
import 'package:rec_you/util/SharedPreferences.dart';

class UserActions {
  List<User> users = List();

  Future getUsers() async {
    final response = await http
        .get('https://musicstreaming-backend.azurewebsites.net/api/user');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      users = (data as List).map((json) {
        return User.fromJSON(json);
      }).toList();
      return users;
    } else {
      print("Error in URL");
    }
  }

  Future getFilteredUsers(String filteredUser) async {
    final response = await http.get(
      'https://musicstreaming-backend.azurewebsites.net/api/search/$filteredUser',
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer " + await SharedPreferencesHelper.getToken()
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      users = (data as List).map((json) {
        return User.fromJSON(json);
      }).toList();
      return users;
    } else {
      print("Error in URL");
    }
  }

  Future userProfile(String username) async {
    final response = await http.get(
      'https://musicstreaming-backend.azurewebsites.net/api/user/$username/false',
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer " + await SharedPreferencesHelper.getToken()
      },
    );
    if (response.statusCode == 200) {
      Map userMap = jsonDecode(response.body);
      var user = FullUser.fromJSON(userMap);
      return user;
    } else {
      print("Error in URL");
    }
  }

  Future userExist(String username) async {
    final response = await http.get(
        'https://musicstreaming-backend.azurewebsites.net/api/user/exists/' +
            username,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        });
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print("Error in URL");
    }
  }
}
