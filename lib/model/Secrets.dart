class Secrets{
  String user, secret;

  Secrets({this.user, this.secret});

  factory Secrets.fromJSON(Map<String, dynamic> json) {
    return Secrets(
        user: json['cloudinary_user'].toString(),
        secret: json['cloudinary_key'].toString());
  }
}