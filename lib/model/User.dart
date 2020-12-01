import 'Follow.dart';
import 'Post.dart';

class User {
  String username, password, avatar;

  User({this.username, this.password, this.avatar});

  factory User.fromJSON(Map<String, dynamic> json) {
    return User(
        username: json['username'].toString(),
        avatar: json['pic_url'].toString());
  }
}

class FullUser {
  String username, avatar;
  List<Post> posts;
  List<Follower> followers;
  List<Following> following;

  FullUser(
      {this.username, this.avatar, this.posts, this.followers, this.following});

  factory FullUser.fromJSON(Map<String, dynamic> json) {
    return FullUser(
      username: json['username'].toString(),
      avatar: json['pic_url'].toString(),
      posts: json['posts'].map<Post>((i) => Post.fromJSON(i)).toList(),
      following: json['following']
          .map<Following>((i) => Following.fromJSON(i))
          .toList(),
      followers:
          json['followers'].map<Follower>((i) => Follower.fromJSON(i)).toList(),
    );
  }
}
