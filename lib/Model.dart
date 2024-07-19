class StudentLogin {
  final String name;
  final String PRN;
  final String Semester;
  final String Branch;
  final String Division;
  final String Batch;
  bool isPresent;

  StudentLogin({
    required this.name,
    required this.PRN,
    required this.Semester,
    required this.Branch,
    required this.Division,
    required this.Batch,
    this.isPresent = false,
  });

  factory StudentLogin.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw ArgumentError('Cannot create StudentLogin from null JSON');
    }
    String name = json['Name'] ?? '';
    String PRN = json['PRN'] ?? '';
    String Semester = json['SEMESTER'] ?? '';
    String Branch = json['BRANCH'] ?? '';
    String Division = json['DIVISION'] ?? '';
    String Batch = json['BATCH'] ?? '';

    return StudentLogin(
      name: name,
      PRN: PRN,
      Branch: Branch,
      Division: Division,
      Batch: Batch,
      Semester: Semester,
    );
  }
}


class FacultyLogin {
  final int Faculty_id;
  final String Faculty_name;
  List<String> Subjects;

  FacultyLogin({required this.Faculty_id, required this.Faculty_name, required this.Subjects});

  factory FacultyLogin.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('Cannot create Faculty from null JSON');
    }
    int Faculty_id = json['Faculty_id'] ?? 0;
    String Faculty_name = json['Faculty_name'] ?? '';
    String subjectString = json['subjects_taught'] ?? '';
    List<String> subjects = subjectString.isNotEmpty
        ? subjectString.split(',').map((e) => e.trim()).toList()
        : [];

    return FacultyLogin(Faculty_id: Faculty_id, Faculty_name: Faculty_name, Subjects: subjects);
  }
}



class UserModel {
  String? id;
  String? name;
  String? image;
  FaceFeatures? faceFeatures;
  int? registeredOn;

  UserModel({
    this.id,
    this.name,
    this.image,
    this.faceFeatures,
    this.registeredOn,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      faceFeatures: FaceFeatures.fromJson(json["faceFeatures"]),
      registeredOn: json['registeredOn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'faceFeatures': faceFeatures?.toJson() ?? {},
      'registeredOn': registeredOn,
    };
  }
}

class FaceFeatures {
  Points? rightEar;
  Points? leftEar;
  Points? rightEye;
  Points? leftEye;
  Points? rightCheek;
  Points? leftCheek;
  Points? rightMouth;
  Points? leftMouth;
  Points? noseBase;
  Points? bottomMouth;

  FaceFeatures({
    this.rightMouth,
    this.leftMouth,
    this.leftCheek,
    this.rightCheek,
    this.leftEye,
    this.rightEar,
    this.leftEar,
    this.rightEye,
    this.noseBase,
    this.bottomMouth,
  });

  factory FaceFeatures.fromJson(Map<String, dynamic> json) => FaceFeatures(
    rightMouth: Points.fromJson(json["rightMouth"]),
    leftMouth: Points.fromJson(json["leftMouth"]),
    leftCheek: Points.fromJson(json["leftCheek"]),
    rightCheek: Points.fromJson(json["rightCheek"]),
    leftEye: Points.fromJson(json["leftEye"]),
    rightEar: Points.fromJson(json["rightEar"]),
    leftEar: Points.fromJson(json["leftEar"]),
    rightEye: Points.fromJson(json["rightEye"]),
    noseBase: Points.fromJson(json["noseBase"]),
    bottomMouth: Points.fromJson(json["bottomMouth"]),
  );

  Map<String, dynamic> toJson() => {
    "rightMouth": rightMouth?.toJson() ?? {},
    "leftMouth": leftMouth?.toJson() ?? {},
    "leftCheek": leftCheek?.toJson() ?? {},
    "rightCheek": rightCheek?.toJson() ?? {},
    "leftEye": leftEye?.toJson() ?? {},
    "rightEar": rightEar?.toJson() ?? {},
    "leftEar": leftEar?.toJson() ?? {},
    "rightEye": rightEye?.toJson() ?? {},
    "noseBase": noseBase?.toJson() ?? {},
    "bottomMouth": bottomMouth?.toJson() ?? {},
  };
}

class Points {
  int? x;
  int? y;

  Points({
    required this.x,
    required this.y,
  });

  factory Points.fromJson(Map<String, dynamic> json) => Points(
    x: (json['x'] ?? 0) as int,
    y: (json['y'] ?? 0) as int,
  );

  Map<String, dynamic> toJson() => {'x': x, 'y': y};
}

class StudentList {
  final String semester;
  final String branch;
  // final String batch;
  final String subject;
  final String division;
  final String? name;
  final String? prn;
  bool isPresent;

  StudentList({
    required this.semester,
    required this.branch,
    // required this.batch,
    required this.subject,
    required this.division,
    this.name,
    this.prn,
    this.isPresent = false,
  });
}

class ConnectedStudent {
  final String? studentName;
  final String? semester1;
  final String? branch;
  // final String? batch;
  final String? division;
  final String? PRN;
  final DateTime? datetime;
  ConnectedStudent({
    // this.batch,
    this.division,
    this.studentName, this.semester1, this.branch, this.PRN, this.datetime});
}
