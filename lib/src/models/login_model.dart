class LoginModel {
  final String uuid;
  final String username;
  final String md5;
  final String sha1;
  final String sha256;

  LoginModel({
    required this.uuid,
    required this.username,
    required this.md5,
    required this.sha1,
    required this.sha256,
  });

  factory LoginModel.fromMap(dynamic map) {
    return LoginModel(
      uuid: map['uuid'] as String,
      username: map['username'] as String,
      md5: map['md5'] as String,
      sha1: map['sha1'] as String,
      sha256: map['sha256'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'username': username,
      'md5': md5,
      'sha1': sha1,
      'sha256': sha256,
    };
  }
}
