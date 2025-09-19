
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
  ResultData? result;

  Quizesdata({
    required this.id,
    required this.classroom,
    required this.quizName,
    required this.createdAt,
    this.result  
  });

  factory Quizesdata.fromJson(Map<String, dynamic> json) {
    return Quizesdata(
      id: json['id'] as int,
      classroom: json['classroom'], 
      quizName : json['quiz_name'],
      createdAt: DateTime.parse(json['created_at']),
      result: json['result'] != null 
        ? ResultData.fromJson(json['result']) 
        : null,
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


class answerDataRequest{
  final int quiz_id;
  final int question_id;
  final int answer_id;

  answerDataRequest({
    required this.quiz_id,
    required this.question_id,
    required this.answer_id,
  });

  Map<String, dynamic> toJson(){
    return{
      'quiz_id' : quiz_id,
      'question_id': question_id,
      'answer_id' :answer_id,
    };
  }
}

class answerDataResponse {
  final int status;
  final String message;
  final answerData data;

  answerDataResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory answerDataResponse.fromJson(Map<String, dynamic> json) {
    return answerDataResponse(
      status: json["status"],
      message: json["message"],
      data: answerData.fromJson(json['data']),
    );
  }
}

class answerData{
  final int answer;
  final bool is_correct;

  answerData({
    required this.answer,
    required this.is_correct,
  });

  factory answerData.fromJson(Map<String, dynamic> json) {
    return answerData(
      answer: json['answer'],
      is_correct: json['is_correct'],
    );
  }
}

class ResultData {
  final int id;
  final int score;
  final String answeredAt;
  final int student;
  final int quiz;

  ResultData({
    required this.id,
    required this.score,
    required this.answeredAt,
    required this.student,
    required this.quiz,
  });

  factory ResultData.fromJson(Map<String, dynamic> json) {
    return ResultData(
      id: json['id'] as int,
      score: json['score'] as int,
      answeredAt: json['answered_at'] as String,
      student: json['student'] as int,
      quiz: json['quiz'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'score': score,
      'answered_at': answeredAt,
      'student': student,
      'quiz': quiz,
    };
  }
}



