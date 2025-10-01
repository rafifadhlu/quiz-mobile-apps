import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'package:mobile_english_learning/repositories/user/user_repository.dart';
import 'package:mobile_english_learning/utils/shared_prefs.dart';

import 'package:mobile_english_learning/models/quiz_model.dart';


class QuizRepository {
  // static const String baseUrl = '10.0.2.2:8000'; //emulator
  // static const String baseUrl = '192.168.1.9:8000'; //wifi
  static const String baseUrl = '203.83.46.48:40700'; //public

  Future<Quizesdata> CreateNewQuiz(quizzezRequest request,int classroomID) async{
    final url = Uri.http(baseUrl, 'api/v1/classrooms/${classroomID}/quizzes/');
    final _token = await SharedPrefUtils.readPrefStr('access_token');

    final response = await http.post(url,
      headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
        },
        body: json.encode(request.toJson())
        );

      if (response.statusCode == 201) {
        final body = jsonDecode(response.body);
        debugPrint("Status code : ${response.body}");
        debugPrint("Status code : ${Quizesdata.fromJson(body)}");
        return Quizesdata.fromJson(body);
      } else if (response.statusCode == 401) {
        // token expired → try refresh
        final newToken = await UserRepository().getNewAccessToken();
        if (newToken != null) {
          // retry the original request
             final retryResponse = await http.post(url,
              headers: {
                      'Content-Type': 'application/json',
                      'Authorization': 'Bearer $_token',
                },
                body: json.encode(request.toJson())
                );

          if (retryResponse.statusCode == 200) {
            final body = jsonDecode(retryResponse.body);
            return Quizesdata.fromJson(body);
          }
        }
        throw Exception('Unauthorized: Token expired and refresh failed');
      } else {
        throw Exception('Failed to fetch classrooms. Code: ${response.statusCode}');
      }


  }

  Future<void> deleteQuizByid(int classroomID,int quizID) async{

    var url = Uri.http(baseUrl, 'api/v1/classrooms/${classroomID}/quizzes/${quizID}/');
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

  Future<getQuizzesResponse> getQuizzezByid(int id) async{
      var url = Uri.http(baseUrl, 'api/v1/classrooms/$id/quizzes/');
      final _token = await SharedPrefUtils.readPrefStr('access_token');

      debugPrint("Hit url.........");
      final response = await http.get(url,
      headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
        });

      debugPrint("Raw response body: ${response.body}");


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
        final body = jsonDecode(response.body);
        debugPrint("Status code : ${response.body}");
        debugPrint("Status code : ${getQuizzesResponse.fromJson(body)}");
        throw Exception('Failed to fetch classrooms. Code: ${response.statusCode}');
      }
  }

  Future<getQuestionsResponse> getAllQuestionsofQuiz(int classroomId, int quizID) async{
      var url = Uri.http(baseUrl, 'api/v1/classrooms/$classroomId/quizzes/$quizID/questions/');
      final _token = await SharedPrefUtils.readPrefStr('access_token');

      debugPrint("Hit url.........");

      debugPrint("classroomID : ${classroomId} , quizID : ${quizID} ");

      final response = await http.get(url,
      headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
      });

      if (response.statusCode == 200) {
        debugPrint("Raw response: ${response.body}");
        final body = jsonDecode(response.body);
        return getQuestionsResponse.fromJson(body);
      }
        else if (response.statusCode == 401) {
        // token expired → try refresh
        debugPrint('got 401');
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

  Future<void> deleteQuestion(int classroomID, int quizID, int questionID) async{
 
    var url = Uri.http(baseUrl, 'api/v1/classrooms/$classroomID/quizzes/$quizID/questions/$questionID/');
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

  Future<addQuestionResult> addQuestions(
        List<QuestionRequest> requests, // <-- send list, not single request
        List<List<File?>> imagesFilesPerQuestion, // <-- list of lists
        List<List<File?>> audiosFilesPerQuestion,
        int classroomID,
        int quizID,
      ) async {
        final url = Uri.http(
          baseUrl,
          'api/v1/classrooms/$classroomID/quizzes/$quizID/questions/',
        );

        final _token = await SharedPrefUtils.readPrefStr('access_token');
        final reqMultipart = http.MultipartRequest('POST', url);

        reqMultipart.headers.addAll({
          'Authorization': 'Bearer $_token',
        });

        // Build questions payload
        final payloadList = requests.map((q) {
          final map = q.toJson();
          map.remove('question_image');
          map.remove('question_audio');
          return map;
        }).toList();

        final questionsPayload = jsonEncode(payloadList);
        debugPrint("📤 Sending questions payload: $questionsPayload");
        reqMultipart.fields['questions'] = questionsPayload;

        // Attach image files per question with indexed keys
        for (var i = 0; i < imagesFilesPerQuestion.length; i++) {
          for (var img in imagesFilesPerQuestion[i]) {
            if (img != null) {
              debugPrint("📎 Attaching image for question $i: ${img.path}");
              reqMultipart.files.add(
                await http.MultipartFile.fromPath(
                  'images_files[$i]', // ✅ indexed so backend knows which question
                  img.path,
                ),
              );
            }
          }
        }

        // Attach audio files per question
        for (var i = 0; i < audiosFilesPerQuestion.length; i++) {
          for (var audio in audiosFilesPerQuestion[i]) {
            if (audio != null) {
              debugPrint("🎧 Attaching audio for question $i: ${audio.path}");
              reqMultipart.files.add(
                await http.MultipartFile.fromPath(
                  'audio_files[$i]',
                  audio.path,
                ),
              );
            }
          }
        }

        final response = await reqMultipart.send();
        final responseBody = await response.stream.bytesToString();

        debugPrint("📥 Raw API response: $responseBody");

        final json = jsonDecode(responseBody);
        return addQuestionResult.fromJson(json);
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

  Future<ResultData> getResultSpecify(int classroomId,int quizID,int userID) async{
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
        return ResultData.fromJson(body);
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
            return ResultData.fromJson(body);
          }
          }
          throw Exception('Unauthorized: Token expired and refresh failed');
        } else {
          throw Exception('Failed to fetch classrooms. Code: ${response.statusCode}');
        }
  }


  Future<QuestionData> fetchSingleQuestions(int classroomID,int quizID,int questionID)async{
    var url = Uri.http(baseUrl, 'api/v1/classrooms/$classroomID/quizzes/$quizID/questions/$questionID');
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
        return QuestionData.fromJson(body);
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
            return QuestionData.fromJson(body);
          }
          }
          throw Exception('Unauthorized: Token expired and refresh failed');
        } else {
          throw Exception('Failed to fetch classrooms. Code: ${response.statusCode}');
        }
  }

  Future<QuestionData?> updateQuestion({
      required int classroomId,
      required int quizId,
      required int questionId,
      required QuestionData question,
      File? imageFile,
      File? audioFile,
    }) async {
      var url = Uri.http(baseUrl, 'api/v1/classrooms/$classroomId/quizzes/$quizId/questions/$questionId');
      final _token = await SharedPrefUtils.readPrefStr('access_token');

      debugPrint('Updating question at: $url');
      debugPrint('Has image: ${imageFile != null}');
      debugPrint('Has audio: ${audioFile != null}');

      try {
        var request = http.MultipartRequest('PUT', url);

        request.headers.addAll({
          'Authorization': 'Bearer $_token'
        });

        request.fields['question_text'] = question.question_text;
        request.fields['choices'] = jsonEncode(question.choices.map((c) => c.toJson()).toList());

        if (imageFile != null) {
          request.files.add(await http.MultipartFile.fromPath('question_image', imageFile.path));
        }

        if (audioFile != null) {
          request.files.add(await http.MultipartFile.fromPath('question_audio', audioFile.path));
        }

        debugPrint('Sending request...');
        final response = await request.send();
        final responseBody = await response.stream.bytesToString();

        debugPrint('JSON being sent: ${request.fields['choices']}');
        debugPrint('Response status: ${response.statusCode}');
        debugPrint('Response body: $responseBody');
        debugPrint('Response reason: ${response.reasonPhrase}');

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(responseBody);
          return QuestionData.fromJson(jsonData['data']);
        } else {
          debugPrint('ERROR: Failed with status ${response.statusCode}');
          throw Exception('Failed to update question: ${response.statusCode} - $responseBody');
        }
      } catch (e) {
        debugPrint('CAUGHT ERROR: $e');
        rethrow; // Don't swallow the error
      }
    }

  

}