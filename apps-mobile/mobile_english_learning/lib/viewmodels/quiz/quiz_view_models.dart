import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_english_learning/models/quiz_model.dart';
import 'package:mobile_english_learning/repositories/quiz/quiz_repository.dart';
import 'package:mobile_english_learning/utils/shared_prefs.dart';

class QuizViewModels extends ChangeNotifier{
  final QuizRepository _repository;

  QuizViewModels(this._repository);

  bool _isLoading = false;
  String? _errorMessage;
  
  getQuizzesResponse? get quizzes => _quizzes;
  getQuizzesResponse? _quizzes;

  getQuestionsResponse? get questions => _questions;
  getQuestionsResponse? _questions;

  answerDataResponse? get answer => _answer;
  answerDataResponse? _answer;

  QuestionData? get singleQuestion => _singleQuestion;
  QuestionData? _singleQuestion;

  bool _isSuccess = false;
  
  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;


  Future<void> createQuizzez(quizzezRequest req, int classroomID)async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final response = await _repository.CreateNewQuiz(req,classroomID);
      _isSuccess = true;
      debugPrint(_quizzes as String?);

      if (_quizzes != null) {
      _quizzes!.data.add(response);
      }
      notifyListeners();   
    }catch(e){
      _errorMessage = e.toString();
      _isSuccess = false;
      notifyListeners();
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteQuizzByid(int classroomID,int quizID) async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final response = await _repository.deleteQuizByid(classroomID, quizID);
      _isSuccess = true;
      notifyListeners();   
    }catch(e){
      _errorMessage = e.toString();
      _isSuccess = false;
      notifyListeners();
    }finally{
      _isLoading = false;
      notifyListeners();
    }
}

  Future<void> getQuizzezByid(int id, bool is_student) async {
  _isLoading = true;
  _errorMessage = null;
  final userID = await SharedPrefUtils.readPrefStr('user_id');
  notifyListeners();

  try {
    final response = await _repository.getQuizzezByid(id);
    _quizzes = response;
    _isSuccess = true;

    // Fetch result for each quiz
    if(is_student){
      for (final quiz in _quizzes!.data) {
        try {
          final result = await getResultSpecify(id, quiz.id, int.parse(userID!));
          quiz.result = result; // attach result if found
        } catch (e) {
          quiz.result = null; // quiz not attempted yet (404, etc.)
        }
      }
    }


    debugPrint("Loaded quizzes:}");
    notifyListeners();

  } catch (e) {
    _errorMessage = e.toString();
    _isSuccess = false;
    notifyListeners();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  Future<void> getAllQuestionsofQuiz(int classroomID, int quizID) async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    _questions = null;

    try{
      final response = await _repository.getAllQuestionsofQuiz(classroomID,quizID);
      _questions = response;
      _isSuccess = true;
      // debugPrint(_quizzes as String?);
      notifyListeners();   
    }catch(e){
      _errorMessage = e.toString();
      _isSuccess = false;
      notifyListeners();
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteQuestion(int classroomID,int quizID,int questionID) async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final response = await _repository.deleteQuestion(classroomID, quizID,questionID);
      _isSuccess = true;
      notifyListeners();   
    }catch(e){
      _errorMessage = e.toString();
      _isSuccess = false;
      notifyListeners();
    }finally{
      _isLoading = false;
      notifyListeners();
    }
}

  Future<void> addQuestions(
      List<QuestionRequest> requests,
      List<List<File?>> imagesFilesPerQuestion,
      List<List<File?>> audiosFilesPerQuestion,
      int classroomID,
      int quizID,
    ) async {
      _isLoading = true;
      _errorMessage = null;

      debugPrint("🚀 Sending batch questions...");

      try {
        final response = await _repository.addQuestions(
          requests,
          imagesFilesPerQuestion,
          audiosFilesPerQuestion,
          classroomID,
          quizID,
        );

        _isSuccess = true;
        debugPrint("✅ API response: ${response.status} - ${response.message}");

        notifyListeners();
      } catch (e) {
        _errorMessage = e.toString();
        _isSuccess = false;
        debugPrint("❌ Error: $_errorMessage");
        notifyListeners();
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }

  Future<void> fetchSingleQuestions(int classroomID,int quizID,int questionID) async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final response = await _repository.fetchSingleQuestions(classroomID, quizID, questionID);
      _singleQuestion = response;
      _isSuccess = true;
      // debugPrint(_quizzes as String?);
      notifyListeners();   
    }catch(e){
      _errorMessage = e.toString();
      _isSuccess = false;
      notifyListeners();
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

   Future<void> updateQuestion(
    int classroomId,
    int quizId,
    int questionId,
    QuestionData question, {
    File? imageFile,
    File? audioFile,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final updated = await _repository.updateQuestion(
        classroomId: classroomId,
        quizId: quizId,
        questionId: questionId,
        question: question,
        imageFile: imageFile,
        audioFile: audioFile,
      );

      if (updated != null) {
        await getAllQuestionsofQuiz(classroomId, quizId);
      }

      _singleQuestion = updated;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitUserAnswer(
    answerDataRequest request, int classroomID, int quizId) async {
  _isLoading = true;
  _errorMessage = null;
  final userID = await SharedPrefUtils.readPrefStr('user_id');
  notifyListeners();

  debugPrint("FROM MODELS : ${classroomID} ");

  try {
    final response = await _repository.submitUserAnswer(request, classroomID, quizId);
    _answer = response;
    _isSuccess = true;
    debugPrint("Submitting answer: ${request.toJson()}");
    debugPrint("API response: $response");

    notifyListeners();
  } catch (e) {
    _errorMessage = e.toString();
    _isSuccess = false;
    notifyListeners();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  Future<ResultData?> getResultSpecify(int classroomId, int quizID, int userID) async {
  try {
    final response = await _repository.getResultSpecify(classroomId, quizID, userID);
    return response; // assuming repository returns resultData
  } catch (e) {
    // if 404 → quiz not attempted
    return null;
  }
}


  void reset(){
    _quizzes = null;
    _questions = null;
    _answer = null;
    _singleQuestion = null;
    _errorMessage = '';
    notifyListeners();
  }


}