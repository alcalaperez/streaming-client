import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rec_you/stores/UserStore.dart';

class FileManager {

  _imgFromCamera(context) async {
    UserStore store = Provider.of<UserStore>(context, listen: false);
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      store.picture = File(pickedFile.path);
    } else {
      print('No image selected.');
      return null;
    }
  }

  _imgFromGallery(context) async {
    UserStore store = Provider.of<UserStore>(context, listen: false);
    final pickedFile =
    await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      store.picture = File(pickedFile.path);
    } else {
      print('No image selected.');
      return null;
    }
  }

   showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        Navigator.of(context).pop();
                        _imgFromGallery(context);
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      Navigator.of(context).pop();
                      _imgFromCamera(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}