import 'package:flutter/material.dart';

///Login
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

///Register
class RegisterRequest {
  final String username;
  final String password;
  final String email;
  final String firstname;
  final String lastname;

  RegisterRequest({
    required this.username,
    required this.password,
    required this.email,
    required this.firstname,
    required this.lastname,
  });


  Map<String, dynamic> toJson() {
    return {
      'username':username,
      'password':password,
      'email':email,
      'firstname':firstname,
      'lastname':lastname,
    };
  }
}

class registerResponse{
  final int status;
  final String message;
  final userDataRegister user;

  registerResponse({
    required  this.status,
    required this.message,
    required this.user,
  });

  factory registerResponse.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];

      debugPrint("🟢 userJson: $userJson");
      debugPrint("🟢 userJson runtimeType: ${userJson.runtimeType}");

      if (userJson == null) {
        debugPrint("⚠️ No user object found in response: $json");
        throw Exception("Missing user data in response");
      }
    
  return registerResponse(
    status: json['status'] ?? 0,
    message: json['message'] ?? '',
    user: userDataRegister.fromJson(json['user'])
      );
    }

}

class userDataRegister{
   final String first_name;
   final String last_name;
   final String email;
   final String username;

   userDataRegister({
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.username,
   });

   factory userDataRegister.fromJson(Map<String,dynamic> json){
    
    return userDataRegister(
      first_name: json['first_name'], 
      last_name: json['last_name'], 
      email: json['email'], 
      username: json['username']);
   }
   

}


///Token
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

///Update profile
class updateProfileRequest{
  final String? username;
  final String? first_name;
  final String? last_name;
  final String? email;

  updateProfileRequest({
    this.username,
    this.first_name,
    this.last_name,
    this.email,
  });

  Map<String,dynamic> toJson(){
    return{
      'username':username,
      'first_name':first_name,
      'last_name':last_name,
      'email':email,
    };
  }
}

// class updateProfileResponse{
//   final int status;
//   final String message;
//   final updateProfileData data;

//   updateProfileResponse({
//     required this.status,
//     required this.message,
//     required this.data,
//   });

//   factory updateProfileResponse.fromJson(Map<String, dynamic> json) {
//     return updateProfileResponse(
//       status: json['status'],
//       message: json['message'],
//       data: updateProfileData.fromJson(json['data']),
//     );
//   }
// }

class updateProfileData{
  final String? username;
  final String? first_name;
  final String? last_name;
  final String? email;

  updateProfileData({
    this.username,
    this.first_name,
    this.last_name,
    this.email,
  });

  factory updateProfileData.fromJson(Map<String, dynamic> json){
    return updateProfileData(
      email: json['email'] ?? '',
      username: json['username'] ??'',
      first_name:json['first_name'] ??'',
      last_name: json['last_name'] ?? '',
    );
  }

    Map<String, dynamic> toJson(){
      return {
        'email': email ?? '',
        'username': username ??'',
        'first_name':first_name ??'',
        'last_name': last_name ?? '',
      };
    }

    updateProfileData changeData({
      String? username,
      String? email,
      String? first_name,
      String? last_name,
    }){
      return updateProfileData(
        username: username ?? this.username,
        email: email ?? this.email,
        first_name: first_name ?? this.first_name,
        last_name: last_name ?? this.last_name,
      
      );
    }
}