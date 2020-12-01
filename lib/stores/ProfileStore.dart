import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:rec_you/model/Follow.dart';
import 'package:rec_you/model/User.dart';
import 'package:rec_you/network/RelationActions.dart';
import 'package:rec_you/network/UserActions.dart';
import 'package:rec_you/util/SharedPreferences.dart';

part 'ProfileStore.g.dart';

class ProfileStore = _ProfileStore with _$ProfileStore;

abstract class _ProfileStore with Store {
  final UserActions userClient = UserActions();
  final RelationsActions relationClient = RelationsActions();

  bool ownProfile = false;
  bool isFollowed = false;

  @observable
  ObservableFuture<FullUser> profile;

  @observable
  ObservableFuture<Text> profileText;

  @action
  Future fetchProfile(String username) => profile = ObservableFuture(
      userClient.userProfile(username).then((profile) => profile));

  @action
  Future follow(String userToFollow) =>
      ObservableFuture(relationClient.followUser(userToFollow));

  @action
  Future unfollow(String userToUnfollow) =>
      ObservableFuture(relationClient.unfollowUser(userToUnfollow));

  @action
  void removeOld() => profile = null;

  @action
  void removePost(String id) =>
      profile.value.posts.removeWhere((element) => element.id == id);

  Future<void> getUserProfile(String username) async {
    String systemUsername = await SharedPreferencesHelper.getUsername();
    if (systemUsername == username) {
      ownProfile = true;
    } else {
      ownProfile = false;
    }
    await fetchProfile(username);
    isFollowed = false;
    for (Follower user in profile.value.followers) {
      if (user.username == systemUsername) {
        isFollowed = true;
      }
    }
  }

  Future<void> followUser(String userToFollow) async {
    await follow(userToFollow);
  }

  Future<void> unfollowUser(String userToUnfollow) async {
    await unfollow(userToUnfollow);
  }
}
