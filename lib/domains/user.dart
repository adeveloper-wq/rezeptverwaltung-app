class User {
  int userId;
  String name;
  String email;
  String accessToken;

  User({this.userId, this.name, this.email, this.accessToken});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        userId: responseData['id'],
        name: responseData['name'],
        email: responseData['email'],
        accessToken: responseData['access_token']
    );
  }
}