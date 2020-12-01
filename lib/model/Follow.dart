class Follower {
  String username, createdAt;

  Follower({this.username, this.createdAt});

  factory Follower.fromJSON(Map<String, dynamic> json) {
    return Follower(
      username: json['feedId'].split(':')[1],
      createdAt: json['createdAt'].toString(),
    );
  }
}

class Following {
  String username, createdAt;

  Following({this.username, this.createdAt});

  factory Following.fromJSON(Map<String, dynamic> json) {
    return Following(
      username: json['targetId'].split(':')[1],
      createdAt: json['createdAt'].toString(),
    );
  }
}
