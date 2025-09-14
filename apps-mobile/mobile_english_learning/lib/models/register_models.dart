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
    return registerResponse(
      status: json['status'],
      message: json['message'],
      user: userDataRegister.fromJson(json['data']),
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