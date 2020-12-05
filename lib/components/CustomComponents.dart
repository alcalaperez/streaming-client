import 'package:flutter/material.dart';
import 'package:rec_you/model/User.dart';
import '../stores/PostStore.dart';

class CustomComponents {
  static Material customButton(
      String text, BuildContext context, Function pressed) {
    return Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.red,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width - 30,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: pressed,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ));
  }

  /// Follow/Unfollow/Username
  ///
  /// Shows Follow button if the user is not followed
  /// Shows Unfollow when is followed
  /// Shows the Username text when it is the own user profile
  Widget followUnfollowButton(
      PostStore pstore, BuildContext context, String username) {
    if (pstore.profileStore.ownProfile) {
      return Text(
        username,
        style: TextStyle(fontSize: 24),
      );
    } else {
      if (pstore.profileStore.isFollowed) {
        return FlatButton(
          child: Text("Unfollow " + username),
          color: Colors.black,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.white, width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(20)),
          onPressed: () {
            pstore.getThePostsAndUnfollow(username);
            Navigator.pop(context);
          },
        );
      } else {
        return FlatButton(
          child: Text("Follow " + username),
          color: Colors.black,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.white, width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(20)),
          onPressed: () {
            pstore.getThePostsAndFollow(username);
            Navigator.pop(context);
          },
        );
      }
    }
  }

  static List<Row> profileTopComponents(
      PostStore pstore, BuildContext context, FullUser profile) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomComponents()
              .followUnfollowButton(pstore, context, profile.username),
          SizedBox(height: 20)
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
            child: Text("Followers: " + profile.followers.length.toString()),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Followers'),
                      content: Container(
                        width: double.minPositive,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: profile.followers.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(profile.followers[index].username),
                              onTap: () async {
                                Navigator.pop(context);
                                await pstore.profileStore.getUserProfile(
                                    profile.followers[index].username);
                              },
                            );
                          },
                        ),
                      ),
                    );
                  });
            },
          ),
          SizedBox(width: 10),
          FlatButton(
            child: Text("Following: " + profile.following.length.toString()),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Following'),
                      content: Container(
                        width: double.minPositive,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: profile.following.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(profile.following[index].username),
                              onTap: () async {
                                Navigator.pop(context);
                                await pstore.profileStore.getUserProfile(
                                    profile.following[index].username);
                              },
                            );
                          },
                        ),
                      ),
                    );
                  });
            },
          ),
        ],
      ),
    ];
  }

  static TextField customEditText(String hint, bool hideText, Color borderColor,
      TextEditingController controller) {
    return TextField(
        obscureText: hideText,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: hint,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(32.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(32.0),
          ),
        ));
  }
}
