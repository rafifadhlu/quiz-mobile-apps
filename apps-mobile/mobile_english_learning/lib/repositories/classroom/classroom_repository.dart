import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'package:mobile_english_learning/models/classroom_models.dart';
import 'package:mobile_english_learning/models/user_models.dart';
import 'package:mobile_english_learning/repositories/user/user_repository.dart';
import 'package:mobile_english_learning/utils/shared_prefs.dart';


class ClassroomRepository {
  // static const String baseUrl = '10.0.2.2:8000'; //emulator
  // static const String baseUrl = '192.168.1.9:8000'; //wifi
  static const String baseUrl = '203.83.46.48:40700'; //public

  Future<ClassroomData> createClassroom(CreateClassroomRequest request)async{
    await Future.delayed(Duration(seconds:2));
    var url = Uri.http(baseUrl, '/api/v1/classrooms/');

    final token = await SharedPrefUtils.readPrefStr('access_token');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(request.toJson())
    );

    debugPrint(request.toString());
    debugPrint(response.statusCode.toString());
    debugPrint(response.body.toString());

    if (response.statusCode == 201) {
        final body = jsonDecode(response.body);
        return ClassroomData.fromJson(body);
      } else if (response.statusCode == 401) {
        // token expired → try refresh
        final newToken = await UserRepository().getNewAccessToken();
        if (newToken != null) {
          final retryResponse = await http.post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json', // ✅ include Accept
              'Authorization': 'Bearer $newToken',
            },
            body: json.encode(request.toJson()),
          );

          debugPrint('Retry Status: ${retryResponse.statusCode}');
          debugPrint('Retry Body: ${retryResponse.body}');

          if (retryResponse.statusCode == 201) {
            final body = jsonDecode(retryResponse.body);
            return ClassroomData.fromJson(body);
          }
        }

        throw Exception('Unauthorized: Token expired and refresh failed');
      } else {
        throw Exception('Failed to fetch classrooms. Code: ${response.statusCode}');
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

  Future<void> deleteClassroomsByid(int id) async{

    var url = Uri.http(baseUrl, 'api/v1/classrooms/${id}/');
      final _token = await SharedPrefUtils.readPrefStr('access_token');

      debugPrint("Hit url.........");
      final response = await http.delete(url,
      headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
        });

    if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        debugPrint("Status code : ${response.body}");
      } else if (response.statusCode == 401) {
        // token expired → try refresh
        final newToken = await UserRepository().getNewAccessToken();
        if (newToken != null) {
          // retry the original request
          final response = await http.delete(url,
                headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
             });
        }
        throw Exception('Unauthorized: Token expired and refresh failed');
      } else {
        throw Exception('Failed to fetch classrooms. Code: ${response.statusCode}');
      }
  }

  Future<CandidateClassroomResponse> getCandidateClassrooms(int classroomID)async{
    var url = Uri.http(baseUrl, 'api/v1/classrooms/$classroomID/candidate/');
      final _token = await SharedPrefUtils.readPrefStr('access_token');

      debugPrint("Hit url.........");
      final response = await http.get(url,
      headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
        });

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return CandidateClassroomResponse.fromJson(body);
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
            return CandidateClassroomResponse.fromJson(body);
          }
        }
        throw Exception('Unauthorized: Token expired and refresh failed');
      } else {
        throw Exception('Failed to fetch classrooms. Code: ${response.statusCode}');
      }

  }

  Future<addCandidateRequest> addNewStudents(addCandidateRequest students,int classroomID) async{
    var url = Uri.http(baseUrl, '/api/v1/classrooms/$classroomID/candidate/');

    final token = await SharedPrefUtils.readPrefStr('access_token');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(students.toJson())
    );

    debugPrint(students.toString());
    debugPrint(response.statusCode.toString());
    debugPrint(response.body.toString());

    if (response.statusCode == 201) {
        final body = jsonDecode(response.body);
        return addCandidateRequest.fromJson(body);
      } else if (response.statusCode == 401) {
        // token expired → try refresh
        final newToken = await UserRepository().getNewAccessToken();
        if (newToken != null) {
          final retryResponse = await http.post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json', // ✅ include Accept
              'Authorization': 'Bearer $newToken',
            },
            body: json.encode(students.toJson()),
          );

          debugPrint('Retry Status: ${retryResponse.statusCode}');
          debugPrint('Retry Body: ${retryResponse.body}');

          if (retryResponse.statusCode == 201) {
            final body = jsonDecode(retryResponse.body);
            return addCandidateRequest.fromJson(body);
          }
        }

        throw Exception('Unauthorized: Token expired and refresh failed');
      } else {
        throw Exception('Failed to fetch classrooms. Code: ${response.statusCode}');
      }
  }

  Future<void> removeStudent(int clasroomID,int userID) async{
    var url = Uri.http(baseUrl,'/api/v1/classrooms/$clasroomID/members/$userID/');
    final _token = await SharedPrefUtils.readPrefStr('access_token');

      debugPrint("Hit url.........");
      final response = await http.delete(url,
      headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
        });

    if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        debugPrint("Status code : ${response.body}");
      } else if (response.statusCode == 401) {
        // token expired → try refresh
        final newToken = await UserRepository().getNewAccessToken();
        if (newToken != null) {
          // retry the original request
          final response = await http.delete(url,
                headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
             });
        }
        throw Exception('Unauthorized: Token expired and refresh failed');
      } else {
        throw Exception('Failed to fetch classrooms. Code: ${response.statusCode}');
      }
  }

}