import 'package:flutter/foundation.dart';
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

// Request Models (for sending data)
// class UploadQuestionsRequest {
//   final List<QuestionData> questions;
//   final List<File>? imageFiles;
//   final List<File>? audioFiles;

//   UploadQuestionsRequest({
//     required this.questions,
//     this.imageFiles,
//     this.audioFiles,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'questions': questions.map((q) => q.toJson()).toList(),
//     };
//   }
// }

// class QuestionData {
//   final String questionText;
//   final bool hasImage;
//   final bool hasAudio;
//   final List<ChoiceData> choices;

//   QuestionData({
//     required this.questionText,
//     this.hasImage = false,
//     this.hasAudio = false,
//     required this.choices,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'question_text': questionText,
//       'has_image': hasImage,
//       'has_audio': hasAudio,
//       'choices': choices.map((c) => c.toJson()).toList(),
//     };
//   }
// }

// class ChoiceData {
//   final String choiceText;
//   final bool isCorrect;

//   ChoiceData({
//     required this.choiceText,
//     required this.isCorrect,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'choice_text': choiceText,
//       'is_correct': isCorrect,
//     };
//   }
// }

// // Response Models (for receiving data)
// class QuestionResponse {
//   final String id;
//   final String questionText;
//   final String? questionImage;
//   final String? questionAudio;
//   final List<ChoiceResponse> choices;

//   QuestionResponse({
//     required this.id,
//     required this.questionText,
//     this.questionImage,
//     this.questionAudio,
//     required this.choices,
//   });

//   factory QuestionResponse.fromJson(Map<String, dynamic> json) {
//     return QuestionResponse(
//       id: json['id'].toString(),
//       questionText: json['question_text'] ?? '',
//       questionImage: json['question_image'],
//       questionAudio: json['question_audio'],
//       choices: (json['choices'] as List?)
//           ?.map((choice) => ChoiceResponse.fromJson(choice))
//           .toList() ?? [],
//     );
//   }
// }

// class ChoiceResponse {
//   final String id;
//   final String choiceText;
//   final bool isCorrect;

//   ChoiceResponse({
//     required this.id,
//     required this.choiceText,
//     required this.isCorrect,
//   });

//   factory ChoiceResponse.fromJson(Map<String, dynamic> json) {
//     return ChoiceResponse(
//       id: json['id'].toString(),
//       choiceText: json['choice_text'] ?? '',
//       isCorrect: json['is_correct'] ?? false,
//     );
//   }
// }