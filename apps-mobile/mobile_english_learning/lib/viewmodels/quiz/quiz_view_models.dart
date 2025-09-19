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

  bool _isSuccess = false;
  
  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  Future<void> getDetailClassroomsByid(int id) async {
  _isLoading = true;
  _errorMessage = null;
  final userID = await SharedPrefUtils.readPrefStr('user_id');
  notifyListeners();

  try {
    final response = await _repository.getDetailClassroomsByid(id);
    _quizzes = response;
    _isSuccess = true;

    // Fetch result for each quiz
    for (final quiz in _quizzes!.data) {
      try {
        final result = await getResultSpecify(id, quiz.id, int.parse(userID!));
        quiz.result = result; // attach result if found
      } catch (e) {
        quiz.result = null; // quiz not attempted yet (404, etc.)
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

    try{
      final response = await _repository.getAllQuestionsofQuiz(classroomID,quizID);
      _questions = response;
      _isSuccess = true;
      debugPrint(_quizzes as String?);
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
    _errorMessage = '';
    notifyListeners();
  }


}