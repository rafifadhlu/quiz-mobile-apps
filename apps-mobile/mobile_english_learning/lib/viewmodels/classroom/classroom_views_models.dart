import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile_english_learning/models/classroom_models.dart';
import 'package:mobile_english_learning/repositories/classroom/classroom_repository.dart';

class ClassroomViewsModels extends ChangeNotifier{
  final ClassroomRepository _repository;

  ClassroomViewsModels(this._repository);

  bool _isLoading = false;
  String? _errorMessage;
  
  ClassroomResponse? get classes => _classes;
  ClassroomResponse? _classes;

  GetDetailsClassroomResponse? get details => _details;
  GetDetailsClassroomResponse? _details;

  bool _isSuccess = false;
  
  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  Future<void> getAllclassrooms() async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final response = await _repository.getAllClassrooms();
      _classes = response;
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

  Future<void> getClassDetailById(int id) async{

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final response = await _repository.getDetailClassroomsByid(id);
      _details = response;
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

Future<void> createClassroom(CreateClassroomRequest request)async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

     try{
      final response = await _repository.createClassroom(request);
      _isSuccess = true;
      debugPrint(response.className);

      if (_classes != null) {
      _classes!.data.add(response); // assuming classes.data is List<ClassroomData>
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

Future<void> deleteClassroomByid(int id) async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final response = await _repository.deleteClassroomsByid(id);
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

  void reset(){
    _classes= null;
    _details= null; 
    _errorMessage = '';
    notifyListeners();
  }
}