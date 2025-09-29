import 'package:flutter/material.dart';
import 'package:mobile_english_learning/utils/shared_prefs.dart';

class AppStateViewModel extends ChangeNotifier {
  bool _isFreshOpen = true;
  bool get isFreshOpen => _isFreshOpen;

  Future<void> loadFreshOpenState() async {
  final stored = await SharedPrefUtils.readPrefBool('is_freshOpen');
  _isFreshOpen = stored ?? true;  
  debugPrint("FreshOpen = $_isFreshOpen");
  notifyListeners();
  }


  Future<void> setFreshOpen(bool value) async {
    await SharedPrefUtils.saveBool('is_freshOpen', value);
    _isFreshOpen = value;
    notifyListeners();
  }

  
}
