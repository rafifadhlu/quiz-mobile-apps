import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile_english_learning/models/classroom_models.dart';
import 'package:mobile_english_learning/repositories/classroom/classroom_repository.dart';

class ClassroomViewsModels extends ChangeNotifier{
  final ClassroomRepository _repository;

  ClassroomViewsModels(this._repository);

  bool _isLoading = false;
  String? _errorMessage;
  
  ClassroomResponse? _classes;
  bool _isSuccess = false;
  
  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;
  ClassroomResponse? get classes => _classes;
  bool get isSuccess => _isSuccess;

  Future<void> getAllclassrooms() async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final response = await _repository.getAllClassrooms();
      _classes = response;
      _isLoading = true;
      notifyListeners();   
    }catch(e){
      _errorMessage = e.toString();
      _isSuccess = false;
      notifyListeners();
    }finally{
      _isSuccess = true;
      _isLoading = false;
      notifyListeners();
    }
  }

}