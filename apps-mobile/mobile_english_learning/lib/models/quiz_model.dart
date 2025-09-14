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