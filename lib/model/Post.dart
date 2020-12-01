class Post {
  String id, actor, picture, audio, description, foreignId, date;

  Post(
      {this.id,
      this.actor,
      this.picture,
      this.audio,
      this.description,
      this.foreignId,
      this.date});

  factory Post.fromJSON(Map<String, dynamic> json) {
    return Post(
      id: json['id'].toString(),
      actor: json['actor'],
      audio: json['object'].split(',')[0],
      picture: json['object'].split(',')[1],
      description: json['target'],
      date: json['time'],
      foreignId: json['foreignId'],
    );
  }
}
