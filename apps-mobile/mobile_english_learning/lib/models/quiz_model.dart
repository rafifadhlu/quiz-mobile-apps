
import 'dart:ffi';

/// GET all quizes belongs to user
class getQuizzesResponse {
  final int status;
  final String message;
  final List<Quizesdata> data;

  getQuizzesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory getQuizzesResponse.fromJson(Map<String, dynamic> json) {
    return getQuizzesResponse(
      status: json["status"] as int,
      message: json["message"] as String,
      data: (json["data"] as List<dynamic>)
          .map((e) => Quizesdata.fromJson(e))
          .toList(),
    );
  }
}

class Quizesdata{
  final int id;
  final int classroom;
  final String quizName;
  final DateTime createdAt;

  Quizesdata({
    required this.id,
  required this.classroom,
  required this.quizName,
  required this.createdAt,
  });

  factory Quizesdata.fromJson(Map<String, dynamic> json) {
    return Quizesdata(
      id: json['id'] as int,
      classroom: json['classroom'], 
      quizName : json['quiz_name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

///GET all Questions belongs to a quiz
class getQuestionsResponse {
  final int status;
  final String message;
  final List<QuestionsDataResponse> data;

  getQuestionsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory getQuestionsResponse.fromJson(Map<String, dynamic> json) {
    return getQuestionsResponse(
      status: json["status"],
      message: json["message"],
      data: (json["data"] as List<dynamic>)
          .map((e) => QuestionsDataResponse.fromJson(e))
          .toList(),
    );
  }
}

class QuestionsDataResponse{
  final int id;
  final int quiz_id;
  final String question_text;
  final String? question_image_url;
  final String? question_audio_url;
  final List<choiceListData> choices_list;

  QuestionsDataResponse({
    required this.id,
    required this.quiz_id,
    required this.question_text,
    this.question_image_url,
    this.question_audio_url,
    required this.choices_list,
  });

  factory QuestionsDataResponse.fromJson(Map<String, dynamic> json) {
    return QuestionsDataResponse(
      id: json["id"],
      quiz_id: json["quiz_id"],
      question_text: json["question_text"],
      question_image_url: json["question_image_url"],
      question_audio_url: json["question_audio_url"],
      choices_list: (json["choices_list"] as List<dynamic>)
          .map((e) => choiceListData.fromJson(e))
          .toList(),
    );
  }

}

class choiceListData{
  final int id;
  final String choice_text;
  final bool is_correct;

  choiceListData({
    required this.id,
    required this.choice_text,
    required this.is_correct
  });

  factory choiceListData.fromJson(Map<String, dynamic> json) {
    return choiceListData(
      id: json["id"],
      choice_text: json["choice_text"],
      is_correct: json["is_correct"],
    );
  }
}