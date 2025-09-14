class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

class LoginResponse {
  final int status;
  final String message;
  final LoginData data;

  LoginResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      message: json['message'],
      data: LoginData.fromJson(json['data']),
    );
  }
}

class LoginData {
  final String access;
  final String refresh;
  final User user;

  LoginData({
    required this.access,
    required this.refresh,
    required this.user,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      access: json['access'],
      refresh: json['refresh'],
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final int id;
  final String username;
  final String email;
  final String firstname;
  final String lastname;
  final List<String> groups;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.groups,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      groups: List<String>.from(json['groups'] ?? []),
    );
  }
}



class refreshTokenRequest{
  final String refresh_Token;

  refreshTokenRequest({required this.refresh_Token});

  Map<String, dynamic> toJson() {
    return {
      'refreshToken': refresh_Token,
    };
  }
}

class tokenRefreshResponse {
  final int status;
  final String message;
  final tokenData data;

  tokenRefreshResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory tokenRefreshResponse.fromJson(Map<String, dynamic> json) {
    return tokenRefreshResponse(
      status: json['status'],
      message: json['message'],
      data: tokenData.fromJson(json['data']),
    );
  }
}

class tokenData {
  final String access;
  final String refresh;

  tokenData({
    required this.access,
    required this.refresh,
  });

  factory tokenData.fromJson(Map<String, dynamic> json) {
    return tokenData(
      access: json['access'],
      refresh: json['refresh'],
    );
  }
}