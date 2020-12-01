import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rec_you/model/Secrets.dart';
import 'package:rec_you/model/User.dart';
import 'package:rec_you/util/SharedPreferences.dart';

class AuthenticationActions {
  Future login(String username, String pass) async {
    Map data = {'Username': username, 'Password': pass};
    var body = json.encode(data);

    final response = await http.post(
        'https://musicstreaming-backend.azurewebsites.net/api/authenticator',
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: body);
    if (response.statusCode == 200) {
      final userResponse = await http.get(
          'https://musicstreaming-backend.azurewebsites.net/api/user/$username/true',
          headers: {
            HttpHeaders.authorizationHeader:
            "Bearer ${response.body.replaceAll("\"", "")}"
          });
      Map userMap = jsonDecode(userResponse.body);
      var user = User.fromJSON(userMap);
      SharedPreferencesHelper.setToken(response.body.replaceAll("\"", ""));
      SharedPreferencesHelper.setPicUrl(user.avatar);
      SharedPreferencesHelper.setUsername(username);
    } else if (response.statusCode == 401) {
      return "Unauthorized";
    } else {
      return "Error in URL";
    }
  }

  Future register(String username, String pass, File picUrl) async {
    var secrets = await rootBundle.loadString("assets/secrets.json");
    Map secretsDecoded = jsonDecode(secrets);
    Secrets secret = Secrets.fromJSON(secretsDecoded);
    final cloudinary = CloudinaryPublic(secret.user, secret.secret, cache: false);
    Map data;
    CloudinaryResponse cresponse;

    if (picUrl != null) {
      cresponse = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(picUrl.path,
            resourceType: CloudinaryResourceType.Image),
      );

      data = {
        'Username': username,
        'Password': pass,
        'ProfilePictureUrl': cresponse.secureUrl
      };
      SharedPreferencesHelper.setPicUrl(cresponse.secureUrl);
    } else {
      data = {
        'Username': username,
        'Password': pass,
        'ProfilePictureUrl':
        'https://res.cloudinary.com/uo226321/image/upload/v1604013146/default_x6mc5h.png'
      };
      SharedPreferencesHelper.setPicUrl(
          'https://res.cloudinary.com/uo226321/image/upload/v1604013146/default_x6mc5h.png');
    }

    var body = json.encode(data);
    final response = await http.post(
        'https://musicstreaming-backend.azurewebsites.net/api/user',
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: body);
    if (response.statusCode == 200) {
      SharedPreferencesHelper.setToken(response.body.replaceAll("\"", ""));
      SharedPreferencesHelper.setUsername(username);
    } else {
      print("Error in URL");
    }
  }
}