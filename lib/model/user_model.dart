class UserModel {
  UserModel({
    required this.mail,
    required this.userName,
    required this.imageUrl,
    required this.voiceCallId,
  });
  late String mail;
  late String userName;
  late String imageUrl;
  late int voiceCallId;

  UserModel.fromJson(Map<dynamic, dynamic> json) {
    mail = json['email'];
    userName = json['userName'];
    imageUrl = json['imageUrl'];
    voiceCallId = json['voiceCallId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = mail;
    data['username'] = userName;
    data['imageUrl'] = imageUrl;
    data['voiceCallId'] = voiceCallId;
    return data;
  }

  toMap() {}
}
