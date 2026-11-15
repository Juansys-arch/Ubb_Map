import 'dart:convert';

class UserModel {
  const UserModel({
    required this.token,
    required this.uid,
    required this.email,
    this.displayName,
  });

  final String token;
  final String uid;
  final String email;
  final String? displayName;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token']?.toString() ?? '',
      uid: (json['uid'] ?? json['id'])?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      displayName: json['displayName']?.toString(),
    );
  }

  factory UserModel.fromRawJson(String source) =>
      UserModel.fromJson(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => {
        'token': token,
        'uid': uid,
        'email': email,
        if (displayName != null) 'displayName': displayName,
      };

  String toRawJson() => json.encode(toJson());

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          token == other.token &&
          uid == other.uid &&
          email == other.email &&
          displayName == other.displayName;

  @override
  int get hashCode => Object.hash(token, uid, email, displayName);
}
