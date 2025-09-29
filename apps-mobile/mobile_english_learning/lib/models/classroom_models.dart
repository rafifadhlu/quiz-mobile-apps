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
  final String teacher;

  ClassroomData({
    required this.id,
    required this.className,
    required this.teacher,
  });

  factory ClassroomData.fromJson(Map<String, dynamic> json) {
    return ClassroomData(
      id: json['id'] as int,
      className: json['class_name'] as String,
      teacher: json['teacher'],
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


class GetDetailsClassroomResponse {
  final int status;
  final String message;
  final List<DetailClassroom> data;

  GetDetailsClassroomResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetDetailsClassroomResponse.fromJson(Map<String, dynamic> json) {
    return GetDetailsClassroomResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => DetailClassroom.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((c) => c.toJson()).toList(),
    };
  }
}

class DetailClassroom {
  final int id;
  final String className;
  final int teacher;
  final List<Student> students;

  DetailClassroom({
    required this.id,
    required this.className,
    required this.teacher,
    required this.students,
  });

  factory DetailClassroom.fromJson(Map<String, dynamic> json) {
    return DetailClassroom(
      id: json['id'],
      className: json['class_name'],
      teacher: json['teacher'],
      students: (json['students'] as List)
          .map((s) => Student.fromJson(s))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_name': className,
      'teacher': teacher,
      'students': students.map((s) => s.toJson()).toList(),
    };
  }

  void operator [](String other) {}
}

class Student {
  final int id;
  final String email;
  final String studentFirstName;
  final String studentLastname;

  Student({
    required this.id,
    required this.email,
    required this.studentFirstName,
    required this.studentLastname,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      email: json['email'],
      studentFirstName: json['student_first_name'],
      studentLastname: json['student_last_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'student_first_name': studentFirstName,
      'student_last_name': studentLastname,
    };
  }
}

class CandidateClassroomResponse {
  final int status;
  final String message;
  final List<candidateClassroomData> data;

  CandidateClassroomResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CandidateClassroomResponse.fromJson(Map<String, dynamic> json) {
    return CandidateClassroomResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List)
          .map((e) => candidateClassroomData.fromJson(e))
          .toList(),
    );
  }
}


class candidateClassroomData{
  final int id;
  final String first_name;
  final String last_name;
  final String email;
  final bool is_joined;

  candidateClassroomData({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.is_joined
  });

  factory candidateClassroomData.fromJson(Map<String,dynamic> json){
    return candidateClassroomData(
      id:json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      email: json['email'],
      is_joined: json['is_joined']
    );
  }
}

class addCandidateRequest {
  final List<int> students;

  addCandidateRequest({
    required this.students
  });

  Map<String, dynamic> toJson() {
    return {
      'students': students,
    };
  }

  // Optional: Add a factory constructor for creating from JSON
  factory addCandidateRequest.fromJson(Map<String, dynamic> json) {
    return addCandidateRequest(
      students: List<int>.from(json['students'] ?? []),
    );
  }
}