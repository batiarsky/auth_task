class UserEntity {
  String email;
  String password;
  String token;
  int duration;
  bool isRememberedCredentials;

  UserEntity({this.email, this.password, this.token, this.duration, this.isRememberedCredentials});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map["email"] = email;
    map["password"] = password;
    map["token"] = token;
    map["duration"] = duration;
    map["isRememberedCredentials"] = isRememberedCredentials;
    return map;
  }
}