class UserEntity {

  String username;
  String email;
  String password;
  String photoUrl;

  UserEntity({
    required this.username,
    required this.email,
    required this.password,
    required this.photoUrl,
  });

  Map<String, Object?> toDocument(){
    return {
      'username': username,
      'email': email,
      'password': password,
      'photoUrl': photoUrl,
    };
  }

  static UserEntity fromDocument(Map<String, dynamic> doc){
    return UserEntity(
      username: doc['username'],
      email: doc['email'],
      password: doc['password'],
      photoUrl: doc['photoUrl'],
    );
  }
}