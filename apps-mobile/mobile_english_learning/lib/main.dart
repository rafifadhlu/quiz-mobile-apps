import 'package:flutter/material.dart';
import 'package:mobile_english_learning/repositories/quiz/quiz_repository.dart';
import 'package:mobile_english_learning/utils/hex_color_converter.dart';
import 'package:mobile_english_learning/utils/routes.dart';
import 'package:provider/provider.dart';

//repository
import 'package:mobile_english_learning/repositories/user/user_repository.dart';
import 'package:mobile_english_learning/repositories/classroom/classroom_repository.dart';


//Viewsmodel
import 'package:mobile_english_learning/viewmodels/auth/auth_view_models.dart';
import 'package:mobile_english_learning/viewmodels/auth/app_state_view_models.dart';
import 'package:mobile_english_learning/viewmodels/classroom/classroom_views_models.dart';
import 'package:mobile_english_learning/viewmodels/quiz/quiz_view_models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authViewModel = AuthViewModel(UserRepository());
  final appStateViewModel = AppStateViewModel();
  final classroomViewModel = ClassroomViewsModels(ClassroomRepository());
  final quizViewModels = QuizViewModels(QuizRepository());

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
        ChangeNotifierProvider<ClassroomViewsModels>.value(value: classroomViewModel,),
        ChangeNotifierProvider<QuizViewModels>.value(value: quizViewModels)
      ],
      child: MyApp(
        authViewModel: authViewModel,
        appStateViewModel: appStateViewModel,
        classroomViewModel: classroomViewModel,
        quizViewModels: quizViewModels,
      ),
    ),
  );
}


class MyApp extends StatelessWidget {
  final AuthViewModel authViewModel;
  final AppStateViewModel appStateViewModel;
  final ClassroomViewsModels classroomViewModel;
  final QuizViewModels quizViewModels;

  const MyApp({
    super.key,
    required this.authViewModel,
    required this.appStateViewModel,
    required this.classroomViewModel,
    required this.quizViewModels,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = HexColor.fromHex("#102f74");
    
    return MaterialApp.router(
      routerConfig: Createrouters(authViewModel, appStateViewModel,classroomViewModel,quizViewModels),
      theme: ThemeData(
        primaryColor: primaryColor,
        fontFamily: 'Poppins',
        
      ),
    );
  }
}
