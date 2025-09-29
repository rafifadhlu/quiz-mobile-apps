import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:mobile_english_learning/models/user_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  // static const String baseUrl = '10.0.2.2:8000';
  static const String baseUrl = '192.168.1.9:8000';

  Future<LoginResponse> login(LoginRequest request) async{
    await Future.delayed(Duration(seconds:2));
    var url = Uri.http(baseUrl, '/api/v1/auth/login/');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // Change to JSON
        'Accept': 'application/json',
      },
      body: json.encode({  // Use json.encode
        'username': request.username,
        'password': request.password,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      debugPrint("Decoded data: ${jsonEncode(data)}");
      return LoginResponse.fromJson(data);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<registerResponse> register(RegisterRequest request)async{
    // await Future.delayed(Duration(seconds:1));
    var url = Uri.http(baseUrl, '/api/v1/auth/register/');

    final response = await http.post(url,
      headers: {
          'Content-Type': 'application/json', // Change to JSON
          'Accept': 'application/json',
        },
        body: json.encode({  // Use json.encode
          'username': request.username,
          'password': request.password,
          'email': request.email,
          'first_name': request.firstname,
          'last_name': request.lastname,
          
        }),
      );

      if (response.statusCode == 201) {
        final rawData = jsonDecode(response.body);
        if (rawData is! Map<String, dynamic>) {
          throw Exception("Invalid response format: Expected JSON object");
        }
        debugPrint("Decoded data: ${jsonEncode(rawData)}");
        return registerResponse.fromJson(rawData);
      } else {
        throw Exception('Failed to register: ${response.body}');
      }

      }

  Future<updateProfileData> fetchProfileData(int userID) async {
    var url = Uri.http(baseUrl, '/api/v1/auth/profile/$userID/');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return updateProfileData.fromJson(data);
    } else {
      throw Exception("Failed to fetch profile data: ${response.body}");
    }
  }

  Future<updateProfileData> updateProfile(updateProfileData request,int userID) async{
      var url = Uri.http(baseUrl, '/api/v1/auth/profile/$userID/');

      final response = await http.put(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body:jsonEncode(
            request.toJson()
          )
        );

        if(response.statusCode == 200){
          final data = jsonDecode(response.body);
           debugPrint("Raw Data: ${jsonEncode(data)}");

          return updateProfileData.fromJson(data);
        }else {
          throw Exception("Failed to fetch profile data: ${response.body}");
        }
  }


      

  Future<void> BlackListToken(String refresh_token) async{
    var url = Uri.http(baseUrl, '/api/v1/auth/logout/');

    final response = await http.post(url,
      headers: {
          'Content-Type': 'application/json', // Change to JSON
          'Accept': 'application/json',
        },
        body: json.encode({  // Use json.encode
          'refreshToken': refresh_token,
        }),
      );
  }

  Future<String?> getNewAccessToken() async{
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');

    if (refreshToken == null) return null;
    
    var url = Uri.http(baseUrl,'/api/v1/auth/token/');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'refreshToken': refreshToken,
      }),
    );

    if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final newAccessToken = data['data']?['accessToken'];
    final newRefreshToken = data['data']?['refreshToken'];
    if (newAccessToken == null) {
      throw Exception("No accessToken found in response: $data");
    }
    // Save new tokens
    await prefs.setString('access_token', newAccessToken);
    if (newRefreshToken != null) {
        await prefs.setString('refresh_token', newRefreshToken);
      }

      return newAccessToken;
    } else {
      throw Exception('Failed to refresh token: ${response.body}');
    }
  } 

  

}