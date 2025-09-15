import 'package:flutter/material.dart';
import 'package:mobile_english_learning/models/global_models.dart';
import 'package:mobile_english_learning/models/user_models.dart';
import 'package:mobile_english_learning/repositories/user/user_repository.dart';

import 'package:mobile_english_learning/utils/shared_prefs.dart';
import 'package:mobile_english_learning/viewmodels/classroom/classroom_views_models.dart';
import 'package:mobile_english_learning/viewmodels/quiz/quiz_view_models.dart';
import 'package:provider/provider.dart';

class AuthViewModel extends ChangeNotifier {
  final UserRepository _repository;

  AuthViewModel(this._repository);

  bool _isLoading = false;
  String? _errorMessage;
  LoginResponse? _user;
  bool _isLoggedIn = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  LoginResponse? get user => _user;
  bool get isLoggedIn => _isLoggedIn;


  registerResponse? get userRegistered => _userRegistered;
  registerResponse? _userRegistered;

  updateProfileData? get profile => _profile;
  updateProfileData? _profile;


  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;


  Future<void> restoreUserSession() async {
  try {
    final access = await SharedPrefUtils.readPrefStr('access_token');
    final refresh = await SharedPrefUtils.readPrefStr('refresh_token');
    final idStr = await SharedPrefUtils.readPrefStr('user_id');
    final groups = await SharedPrefUtils.readPrefStrList('user_groups') ?? [];


    if (access != null && access.isNotEmpty &&
        refresh != null && refresh.isNotEmpty &&
        idStr != null && idStr.isNotEmpty) {
      final id = int.tryParse(idStr) ?? 0;
      _user = LoginResponse(
        status: 200,
        message: "Restored session",
        data: LoginData(
          access: access,
          refresh: refresh,
          user: User(
            id: id,
            username: await SharedPrefUtils.readPrefStr('user_username') ?? "",
            email: await SharedPrefUtils.readPrefStr('user_email') ?? "",
            firstname: await SharedPrefUtils.readPrefStr('user_firstname') ?? "",
            lastname: await SharedPrefUtils.readPrefStr('user_lastname') ?? "",
            groups:  groups,
          ),
        ),
      );
      _isLoggedIn = true;
      } else {
        _isLoggedIn = false;
      }
    } catch (e) {
      debugPrint("restoreUserSession crashed: $e");
      _isLoggedIn = false; // ✅ fallback
    }

    notifyListeners();
  }


  Future<void> login(String username, String password) async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    final request = LoginRequest(username: username, password: password);
    final response = await _repository.login(request);
    final groups = response.data.user.groups;

    debugPrint('Role :{$groups}');

     // 🔑 Save session in SharedPreferences
      await SharedPrefUtils.saveUserSession(
        accessToken: response.data.access,
        refreshToken: response.data.refresh,
        userId: response.data.user.id,
        username: response.data.user.username,
        email: response.data.user.email,
        firstname: response.data.user.firstname,
        lastname: response.data.user.lastname,
        groups: response.data.user.groups,
      );

    
    debugPrint("Login response parsed successfully");
    debugPrint("User: ${response.data.user.username}"); // ✅ Now this will work
    
    _user = response;
    _isLoggedIn = true;

    debugPrint("isLoggedIn set to: $_isLoggedIn");
    notifyListeners();
    
  } catch (e) {
    debugPrint("Login failed: $e");
    _errorMessage = e.toString();
    _isLoggedIn = false;
    notifyListeners();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  Future<void> registerUser(RegisterRequest request) async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

      try{
        final response = await _repository.register(request);
        // ✅ Check if response indicates success
        if (response.status == 201) {
          _userRegistered = response;
          _isSuccess = true;
        } else {
          _errorMessage = response.message;
          _isSuccess = false;
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

  Future<void> fetchProfile(int userID)async {
      _isLoading = true;
      notifyListeners();
      try {
        final response = await _repository.fetchProfileData(userID);
        _profile = response;
        _errorMessage = null;
      } catch (e) {
        _errorMessage = e.toString();
      } finally {
        _isLoading = false;
        notifyListeners();
      }
  }

  Future<void> updateProfile(updateProfileData request,int userID)async {
      _isLoading = true;
      notifyListeners();
      try {
        final response = await _repository.updateProfile(request,userID);
        _profile = response;
        _errorMessage = null;
      } catch (e) {
        _errorMessage = e.toString();
      } finally {
        _isLoading = false;
        notifyListeners();
      }
  }

  void resetState() {
    _errorMessage = null;
    _isLoading = false;
    _isSuccess = false;
    notifyListeners();
  }


  /// ✅ Clear session
  Future<void> logout(BuildContext context) async {
    _user = null;
    _isLoggedIn = false;
    final refreshToken = await SharedPrefUtils.readPrefStr('refreshToken');

    // Clear saved session
    if (refreshToken != null){
      _repository.BlackListToken(refreshToken);
    }
    await SharedPrefUtils.removePrefs();
    final cleaneup = globalCleanup(
      classroomViewsModels: context.read<ClassroomViewsModels>(), 
      quizViewModels: context.read<QuizViewModels>());

      cleaneup.resetAll();
      
    notifyListeners();
  }
}
