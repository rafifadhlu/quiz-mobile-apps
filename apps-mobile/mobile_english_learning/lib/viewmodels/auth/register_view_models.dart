import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile_english_learning/repositories/user/user_repository.dart';
import 'package:mobile_english_learning/models/register_models.dart';

class RegisterViewModel extends ChangeNotifier{
  final UserRepository _repository;

  RegisterViewModel(this._repository);

  bool _isLoading = false;
  String? _errorMessage;
  registerResponse? _userRegistered;
  bool _isSuccess = false;
  
  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;
  registerResponse? get userRegistered => _userRegistered;
  bool get isSuccess => _isSuccess;

  Future<void> registerUser(
    String username,
    String password,
    String email,
    String first_name,
    String last_name,
  ) async{
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

    try{
      final request = RegisterRequest(
      username:username,
      password:password,
      email:email,
      firstname:first_name,
      lastname:last_name,
      );

      final response = await _repository.register(request);
      _userRegistered = response;
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