import 'package:flutter/material.dart';
import 'package:mobile_english_learning/utils/hex_color_converter.dart';
import 'package:mobile_english_learning/utils/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//repository
import 'package:mobile_english_learning/repositories/user/user_repository.dart';
import 'package:mobile_english_learning/repositories/classroom/classroom_repository.dart';


//Viewsmodel
import 'package:mobile_english_learning/viewmodels/auth/auth_view_models.dart';
import 'package:mobile_english_learning/viewmodels/auth/app_state_view_models.dart';
import 'package:mobile_english_learning/viewmodels/auth/register_view_models.dart';
import 'package:mobile_english_learning/viewmodels/classroom/classroom_views_models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authViewModel = AuthViewModel(UserRepository());
  final appStateViewModel = AppStateViewModel();
  final registerViewModel = RegisterViewModel(UserRepository());
  final classroomViewModel = ClassroomViewsModels(ClassroomRepository());


  await appStateViewModel.loadFreshOpenState();
  try {
  await authViewModel.restoreUserSession();
  } catch (e, st) {
    debugPrint("restoreUserSession failed: $e");
    debugPrintStack(stackTrace: st);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>.value(value: authViewModel),
        ChangeNotifierProvider<AppStateViewModel>.value(value: appStateViewModel),
        ChangeNotifierProvider<RegisterViewModel>.value(value: registerViewModel),
        ChangeNotifierProvider<ClassroomViewsModels>.value(value: classroomViewModel,)
      ],
      child: MyApp(
        authViewModel: authViewModel,
        appStateViewModel: appStateViewModel,
        registerViewModel: registerViewModel,
        classroomViewModel: classroomViewModel,
      ),
    ),
  );
}


class MyApp extends StatelessWidget {
  final AuthViewModel authViewModel;
  final AppStateViewModel appStateViewModel;
  final RegisterViewModel registerViewModel;
  final ClassroomViewsModels classroomViewModel;

  const MyApp({
    super.key,
    required this.authViewModel,
    required this.appStateViewModel,
    required this.registerViewModel,
    required this.classroomViewModel,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = HexColor.fromHex("#102f74");
    
    return MaterialApp.router(
      routerConfig: Createrouters(authViewModel, appStateViewModel,registerViewModel,classroomViewModel),
      theme: ThemeData(
        primaryColor: primaryColor,
        fontFamily: 'Poppins',
        
      ),
    );
  }
}
