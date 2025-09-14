import 'package:flutter/material.dart';
import 'package:mobile_english_learning/models/quiz_model.dart';
import 'package:mobile_english_learning/repositories/quiz/quiz_repository.dart';

class QuizViewModels extends ChangeNotifier{
  final QuizRepository _repository;

  QuizViewModels(this._repository);

  bool _isLoading = false;
  String? _errorMessage;
  
  getQuizzesResponse? get quizzes => _quizzes;
  getQuizzesResponse? _quizzes;

  bool _isSuccess = false;
  
  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  Future<void> getDetailClassroomsByid(int id) async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final response = await _repository.getDetailClassroomsByid(id);
      _quizzes = response;
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


}