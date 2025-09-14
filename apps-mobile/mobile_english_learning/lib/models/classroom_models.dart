class CreateClassroomRequest {
  final String className;

  CreateClassroomRequest({
    required this.className,
  });

  Map<String, dynamic> toJson() {
    return {
      'class_name': className,
    };
  }
}

class ClassroomResponse {
  final int status;
  final String message;
  final List<ClassroomData> data;

  ClassroomResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ClassroomResponse.fromJson(Map<String, dynamic> json) {
    return ClassroomResponse(
      status: json["status"] as int,
      message: json["message"] as String,
      data: (json["data"] as List<dynamic>)
          .map((e) => ClassroomData.fromJson(e))
          .toList(),
    );
  }
}


class ClassroomData {
  final int id;
  final String className;
  final int teacher;

  ClassroomData({
    required this.id,
    required this.className,
    required this.teacher,
  });

  factory ClassroomData.fromJson(Map<String, dynamic> json) {
    return ClassroomData(
      id: json['id'] as int,
      className: json['class_name'] as String,
      teacher: json['teacher'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_name': className,
      'teacher': teacher,
    };
  }
}
