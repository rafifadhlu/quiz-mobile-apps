import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'package:mobile_english_learning/models/classroom_models.dart';
import 'package:mobile_english_learning/models/user_models.dart';
import 'package:mobile_english_learning/repositories/user/user_repository.dart';
import 'package:mobile_english_learning/utils/shared_prefs.dart';


class ClassroomRepository {
  static const String baseUrl = '10.0.2.2:8000';

  Future<ClassroomData> createClassroom(CreateClassroomRequest request)async{
    await Future.delayed(Duration(seconds:2));
    var url = Uri.http(baseUrl, '/api/v1/classrooms/');

    final response = await http.post(url, 
    headers: {
      'Content-Type': 'application/json', // Change to JSON
      'Accept': 'application/json',
      'Authorization': ?await SharedPrefUtils.readPrefStr('access_token'),
    },
    body: json.encode({  // Use json.encode
        'class_name': request.className,
      }),);

    if(response.statusCode == 201){
      final data = jsonDecode(response.body);
      debugPrint("Decoded data: ${jsonEncode(data)}");
      return ClassroomData.fromJson(data);
    }else {
      throw Exception('Failed to login: ${response.body}');
    }

  }
  
  Future<ClassroomResponse> getAllClassrooms() async{
      // await Future.delayed(Duration(seconds:2));
      var url = Uri.http(baseUrl, '/api/v1/classrooms/');
      final _token = await SharedPrefUtils.readPrefStr('access_token');

      debugPrint("Hit url.........");
      final response = await http.get(url,
      headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
        });

        debugPrint("Status code : ${response.statusCode}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return ClassroomResponse.fromJson(body);
      } else if (response.statusCode == 401) {
        // token expired → try refresh
        final newToken = await UserRepository().getNewAccessToken();
        if (newToken != null) {
          // retry the original request
          final retryResponse = await http.get(
              url, // ✅ use the same `url`
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $newToken',
              },
            );

          if (retryResponse.statusCode == 200) {
            final body = jsonDecode(retryResponse.body);
            return ClassroomResponse.fromJson(body);
          }
        }
        throw Exception('Unauthorized: Token expired and refresh failed');
      } else {
        throw Exception('Failed to fetch classrooms. Code: ${response.statusCode}');
      }
    }

  Future<GetDetailsClassroomResponse> getDetailClassroomsByid(int id) async{
      var url = Uri.http(baseUrl, 'api/v1/classrooms/${id}/details/');
      final _token = await SharedPrefUtils.readPrefStr('access_token');

      debugPrint("Hit url.........");
      final response = await http.get(url,
      headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
        });

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return GetDetailsClassroomResponse.fromJson(body);
      } else if (response.statusCode == 401) {
        // token expired → try refresh
        final newToken = await UserRepository().getNewAccessToken();
        if (newToken != null) {
          // retry the original request
          final retryResponse = await http.get(
              url, // ✅ use the same `url`
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $newToken',
              },
            );

          if (retryResponse.statusCode == 200) {
            final body = jsonDecode(retryResponse.body);
            return GetDetailsClassroomResponse.fromJson(body);
          }
        }
        throw Exception('Unauthorized: Token expired and refresh failed');
      } else {
        throw Exception('Failed to fetch classrooms. Code: ${response.statusCode}');
      }


  }
}