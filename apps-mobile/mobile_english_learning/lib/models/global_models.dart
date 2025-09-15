import 'package:mobile_english_learning/viewmodels/classroom/classroom_views_models.dart';
import 'package:mobile_english_learning/viewmodels/quiz/quiz_view_models.dart';

class globalCleanup{
  final ClassroomViewsModels classroomViewsModels;
  final QuizViewModels quizViewModels;
  globalCleanup({
    required this.classroomViewsModels,
    required this.quizViewModels,
  });

  void resetAll(){
    classroomViewsModels.reset();
    quizViewModels.reset();
  }

}