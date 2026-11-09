import 'dart:convert';

class UserModel {
<<<<<<< HEAD
  final String token;
  final String uid;
  final String email;
  final String? displayName;

  UserModel({
=======
  const UserModel({
>>>>>>> 5c3e2cd (feat(tests): actualiza y estandariza la suite de pruebas E2E visuales en integration_test)
    required this.token,
    required this.uid,
    required this.email,
    this.displayName,
  });

<<<<<<< HEAD
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token']?.toString() ?? '',
      uid: json['uid']?.toString() ?? json['id']?.toString() ?? '',
=======
  final String token;
  final String uid;
  final String email;
  final String? displayName;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token']?.toString() ?? '',
      uid: (json['uid'] ?? json['id'])?.toString() ?? '',
>>>>>>> 5c3e2cd (feat(tests): actualiza y estandariza la suite de pruebas E2E visuales en integration_test)
      email: json['email']?.toString() ?? '',
      displayName: json['displayName']?.toString(),
    );
  }

<<<<<<< HEAD
  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str) as Map<String, dynamic>);
=======
  factory UserModel.fromRawJson(String source) =>
      UserModel.fromJson(json.decode(source) as Map<String, dynamic>);
>>>>>>> 5c3e2cd (feat(tests): actualiza y estandariza la suite de pruebas E2E visuales en integration_test)

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
<<<<<<< HEAD
  int get hashCode =>
      token.hashCode ^ uid.hashCode ^ email.hashCode ^ displayName.hashCode;

  @override
  String toString() =>
      'UserModel(token: $token, uid: $uid, email: $email, displayName: $displayName)';
}

=======
  int get hashCode => Object.hash(token, uid, email, displayName);
}
>>>>>>> 5c3e2cd (feat(tests): actualiza y estandariza la suite de pruebas E2E visuales en integration_test)
