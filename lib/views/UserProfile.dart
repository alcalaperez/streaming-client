import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:rec_you/model/User.dart';
import 'package:rec_you/stores/AudioStore.dart';
import 'package:rec_you/stores/PostStore.dart';
import 'package:rec_you/components/CustomComponents.dart';

class UserProfile extends StatefulWidget {
  static const routeName = '/extractArguments';

  UserProfile();

  @override
  _UserProfile createState() {
    return _UserProfile();
  }
}

class _UserProfile extends State<UserProfile> {
  PostStore postStore;
  AudioStore audioStore;
  String username;

  @override
  Future<void> didChangeDependencies() async {
    /// Getting the profile username from the route argument
    username = ModalRoute.of(context).settings.arguments;

    /// Multiple stores
    postStore = Provider.of<PostStore>(context);
    audioStore = Provider.of<AudioStore>(context);

    /// Obtain the profile
    postStore.profileStore.getUserProfile(username);

    /// Callback for audio completion
    audioStore.audioPlayer.onPlayerCompletion.listen((event) {
      audioStore.currentIcon = new Icon(Icons.play_circle_filled);
      setState(() {});
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(centerTitle: true, title: Text("Profile")),
        body: Observer(builder: (_) {
          switch (postStore.profileStore.profile.status) {

            /// Loading profile
            case FutureStatus.pending:
              return Center(
                  child: SpinKitFadingCube(
                      color: Colors.red,
                      duration: Duration(milliseconds: 850)));

            /// Profile loaded
            case FutureStatus.fulfilled:
              FullUser profile = (postStore.profileStore.profile.result);
              return Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: [
                    Column(
                      children: <Widget>[
                        /// Top image with followers/following buttons
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                image: NetworkImage(profile.avatar),
                                fit: BoxFit.cover,
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.4),
                                    BlendMode.dstATop),
                              )),
                          height: 200.0,
                          width: double.infinity,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: CustomComponents.profileTopComponents(
                                  postStore, context, profile)),
                        ),

                        /// List of posts for the selected profile
                        new Expanded(
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: profile.posts.length,
                            itemBuilder: (context, index) {
                              var post = profile.posts[index];
                              return ListTile(
                                title: Text(post.description),
                                subtitle: Text(DateTime.parse(post.date)
                                    .toString()
                                    .split(".")[0]),
                                leading: IconButton(
                                  icon: (audioStore.indexPlaying == index)
                                      ? audioStore.currentIcon
                                      : Icon(Icons.play_circle_filled),
                                  onPressed: () {
                                    if (audioStore.audioPlayer.state ==
                                            AudioPlayerState.PLAYING &&
                                        audioStore.indexPlaying == index) {
                                      audioStore.stop(index);
                                      setState(() {});
                                    } else {
                                      audioStore.play(post.audio, index);
                                      setState(() {});
                                    }
                                  },
                                ),

                                /// 3 dots icon appearing only on owned profile
                                trailing: postStore.profileStore.ownProfile
                                    ? IconButton(
                                        icon: Icon(Icons.more_vert),
                                        onPressed: () {
                                          showAdaptiveActionSheet(
                                            context: context,
                                            barrierColor: Colors.white30,
                                            bottomSheetColor: Colors.black,
                                            actions: <BottomSheetAction>[
                                              BottomSheetAction(
                                                  title: 'Delete post',
                                                  textStyle: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 18),
                                                  onPressed: () {
                                                    postStore.removePost(
                                                        post.id,
                                                        profile.username);
                                                    Navigator.of(context).pop();
                                                  }),
                                            ],
                                            cancelAction: CancelAction(
                                                title: 'Cancel',
                                                textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        18)), // onPressed parameter is optional by default will dismiss the ActionSheet
                                          );
                                        },
                                      )
                                    : SizedBox(),
                              );
                            },
                          ),
                        )
                      ],
                    )
                  ]);
            default:
              return SizedBox();
          }
        }));
  }
}
