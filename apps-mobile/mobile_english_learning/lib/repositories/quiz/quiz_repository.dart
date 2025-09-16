import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'package:mobile_english_learning/repositories/user/user_repository.dart';
import 'package:mobile_english_learning/utils/shared_prefs.dart';

import 'package:mobile_english_learning/models/quiz_model.dart';


class QuizRepository {
  static const String baseUrl = '10.0.2.2:8000';

  Future<getQuizzesResponse> getDetailClassroomsByid(int id) async{
      var url = Uri.http(baseUrl, 'api/v1/classrooms/$id/quizzes/');
      final _token = await SharedPrefUtils.readPrefStr('access_token');

      debugPrint("Hit url.........");
      final response = await http.get(url,
      headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
        });

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        debugPrint("Status code : ${response.body}");
        debugPrint("Status code : ${getQuizzesResponse.fromJson(body)}");
        return getQuizzesResponse.fromJson(body);
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
            return getQuizzesResponse.fromJson(body);
          }
        }
        throw Exception('Unauthorized: Token expired and refresh failed');
      } else {
        throw Exception('Failed to fetch classrooms. Code: ${response.statusCode}');
      }
  }

  Future<getQuestionsResponse> getAllQuestionsofQuiz(int classroomId, int quizID) async{
      var url = Uri.http(baseUrl, 'api/v1/classrooms/$classroomId/quizzes/$quizID/questions/');
      final _token = await SharedPrefUtils.readPrefStr('access_token');

      debugPrint("Hit url.........");
      final response = await http.get(url,
      headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
      });

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        debugPrint(body.toString());
        return getQuestionsResponse.fromJson(body);
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
            return getQuestionsResponse.fromJson(body);
          }
          }
          throw Exception('Unauthorized: Token expired and refresh failed');
        } else {
          throw Exception('Failed to fetch classrooms. Code: ${response.statusCode}');
        }

  }

  Future<answerDataResponse> submitUserAnswer(answerDataRequest request,int classroomId,int quizID) async{
    var url = Uri.http(baseUrl, 'api/v1/classrooms/$classroomId/quizzes/$quizID/answer/');
      final _token = await SharedPrefUtils.readPrefStr('access_token');

      debugPrint("Hit url from quiz repo ${request.toJson()} ");
      final response = await http.post(url,
      headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(request.toJson())
      );

      

      if (response.statusCode == 202) {
        final body = jsonDecode(response.body);
        debugPrint(body.toString());
        return answerDataResponse.fromJson(body);
      } else if (response.statusCode == 401) {
        // token expired → try refresh
        final newToken = await UserRepository().getNewAccessToken();
        if (newToken != null) {
          // retry the original request
          final retryResponse = await http.post(
              url, // ✅ use the same `url`
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $newToken',
              },
              body: request.toJson()
            );

          if (retryResponse.statusCode == 202) {
            final body = jsonDecode(retryResponse.body);
            return answerDataResponse.fromJson(body);
          }
          }
          throw Exception('Unauthorized: Token expired and refresh failed');
        } else {
          throw Exception('Failed to fetch classrooms. Code: ${response.statusCode}');
        }
  }

  Future<resultData> getResultSpecify(int classroomId,int quizID,int userID) async{
    var url = Uri.http(baseUrl, 'api/v1/classrooms/$classroomId/quizzes/$quizID/result/$userID');
      final _token = await SharedPrefUtils.readPrefStr('access_token');

      debugPrint("Hit url.........");
      final response = await http.get(url,
      headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
      },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        debugPrint(body.toString());
        return resultData.fromJson(body);
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
            return resultData.fromJson(body);
          }
          }
          throw Exception('Unauthorized: Token expired and refresh failed');
        } else {
          throw Exception('Failed to fetch classrooms. Code: ${response.statusCode}');
        }
  }
}