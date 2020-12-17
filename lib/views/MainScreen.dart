import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rec_you/util/SharedPreferencesData.dart';
import 'package:rec_you/views/UserProfile.dart';
import 'package:rec_you/util/Animators.dart';
import 'Player.dart';
import '../stores/PostStore.dart';
import 'Search.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PostStore store;
  SharedPreferencesData sharedPref;
  PlayerWidget player = PlayerWidget(url: '', mode: PlayerMode.MEDIA_PLAYER);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    store = Provider.of<PostStore>(context);
    sharedPref = Provider.of<SharedPreferencesData>(context);
    store.getThePosts();
    super.didChangeDependencies();
  }

  recButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, "/record");
      },
      child: Icon(Icons.mic),
      backgroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () => showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                title: Text('Warning'),
                content: Text('Do you really want to exit'),
                actions: [
                  FlatButton(
                    child: Text('Yes'),
                    onPressed: () => SystemNavigator.pop(),
                  ),
                  FlatButton(
                    child: Text('No'),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                ],
              ),
            ),
        child: new Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: SizedBox(
                  height: kToolbarHeight - 10,
                  child: Image.asset('assets/logo_no_name.png')),
              actions: [
                // action button
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Search()),
                    );
                  },
                ),
              ],
              leading: InkWell(
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, UserProfile.routeName,
                          arguments: sharedPref.username);
                    },
                    icon: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(
                          sharedPref.picUrl,
                        )),
                  )),
            ),
            floatingActionButton: recButton(),
            floatingActionButtonLocation: (player.url != '')
                ? FloatingActionButtonLocation.endDocked
                : FloatingActionButtonLocation.endFloat,
            floatingActionButtonAnimator: NoScalingAnimation(),
            bottomNavigationBar: BottomAppBar(
              color: Colors.black,
              notchMargin: 5,
              shape: CircularNotchedRectangle(),
              child: (player.url != '') ? player : null,
            ),
            body: SafeArea(
              child: Observer(
                builder: (_) {
                  if (store.loading) {
                    return Center(
                        child: SpinKitFadingCube(
                            color: Colors.red,
                            duration: Duration(milliseconds: 850)));
                  } else {
                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: store.postsListFuture.length,
                        itemBuilder: (context, index) {
                          var post = store.postsListFuture[index];
                          return ListTile(
                              title: Text(post.actor,
                                  style: TextStyle(
                                    color: store.selectedIndex == index
                                        ? Colors.red
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                              subtitle: Text(post.description,
                                  style: TextStyle(
                                    color: store.selectedIndex == index
                                        ? Colors.red
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                              onTap: () {
                                setState(() {
                                  store.selectedIndex = index;
                                  player.url = post.audio;
                                  player = PlayerWidget(
                                      url: post.audio,
                                      mode: PlayerMode.MEDIA_PLAYER);
                                });
                              },
                              leading: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, UserProfile.routeName,
                                        arguments: post.actor);
                                  },
                                  child: CircleAvatar(
                                      radius: 22,
                                      backgroundColor: store.selectedIndex == index
                                          ? Colors.red
                                          : Colors.transparent,
                                      child: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(post.picture),
                                      ))));
                        },
                      ),
                    );
                  }
                },
              ),
            )));
  }

  Future _refresh() async {
    return await store.fetchPosts();
  }
}
