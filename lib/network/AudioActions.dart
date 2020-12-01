import 'dart:convert';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rec_you/model/Secrets.dart';
import 'package:rec_you/util/SharedPreferences.dart';

class AudioActions {
  Future uploadAudio(String description, File audio) async {
    var secrets = await rootBundle.loadString("assets/secrets.json");
    Map secretsDecoded = jsonDecode(secrets);
    Secrets secret = Secrets.fromJSON(secretsDecoded);
    final cloudinary = CloudinaryPublic(secret.user, secret.secret, cache: false);
    Map data;
    CloudinaryResponse cresponse;

    if (audio != null) {
      cresponse = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(audio.path,
            resourceType: CloudinaryResourceType.Raw),
      );

      data = {
        'Description': description,
        'AudioUrl': cresponse.secureUrl,
        'PictureUrl': await SharedPreferencesHelper.getPicUrl(),
      };

      var body = json.encode(data);
      final response = await http.post(
          'https://musicstreaming-backend.azurewebsites.net/api/posts',
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            HttpHeaders.authorizationHeader:
                "Bearer " + await SharedPreferencesHelper.getToken()
          },
          body: body);
      if (response.statusCode == 200) {
        return "Uploaded";
      } else {
        print("Error in URL");
      }
    }
  }
}
