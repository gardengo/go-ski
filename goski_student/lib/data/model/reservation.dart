

class ReservationRequest {
  int resortId;
  String lessonType; // SKI or BOARD
  int studentCount;
  String lessonDate;
  String startTime;
  int duration;
  String level;

  ReservationRequest({
    this.resortId = 0,
    this.lessonType = 'SKI',
    this.studentCount = 0,
    this.lessonDate = '',
    this.startTime = '',
    this.duration = 0,
    this.level = 'BEGINNER',
  });

  bool isValid() {
    return resortId != 0 &&
        studentCount != 0 &&
        lessonDate != '' &&
        startTime != '' &&
        duration != 0 &&
        level != '';
  }

  Map<String, dynamic> reservationRequestToJson() {
    return {
      "resortId": resortId,
      "lessonType": lessonType,
      "studentCount": studentCount,
      "lessonDate": lessonDate,
      "startTime": startTime,
      "duration": duration,
      "level": level.toUpperCase()
    };
  }
}

class BeginnerResponse {
  int teamId;
  String teamName;
  String description;
  String lessonType;
  String teamProfileUrl;
  List<int> instructors;
  List<TeamImage> teamImages;
  double? rating;
  int? reviewCount;
  int cost;
  int basicFee;
  int designatedFee;
  int peopleOptionFee;
  int levelOptionFee;

  BeginnerResponse({
    this.teamId = 0,
    this.teamName = '',
    this.description = '',
    this.lessonType = '',
    this.teamProfileUrl = '',
    this.instructors = const [],
    this.teamImages = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.cost = 0,
    this.basicFee = 0,
    this.designatedFee = 0,
    this.peopleOptionFee = 0,
    this.levelOptionFee = 0,
  });

  factory BeginnerResponse.fromJson(Map<String, dynamic> json) {
    var list = json['instructors'] as List;
    List<int> instructorsList = list.map((i) => i as int).toList();

    List<TeamImage> teamImages = [];
    if (json['teamImageVOs'] != null) {
      teamImages = (json['teamImageVOs'] as List)
          .map((item) => TeamImage.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return BeginnerResponse(
      teamId: json['teamId'] as int,
      teamName: json['teamName'] as String,
      description: json['description'] as String,
      lessonType: json['lessonType'] as String,
      teamProfileUrl: json['teamProfileUrl'] as String,
      instructors: instructorsList,
      teamImages: teamImages,
      rating: json['rating'] as double? ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      cost: json['cost'] as int,
      basicFee: json['basicFee'] as int? ?? 0,
      designatedFee: json['designatedFee'] as int? ?? 0,
      peopleOptionFee: json['peopleOptionFee'] as int? ?? 0,
      levelOptionFee: json['levelOptionFee'] as int? ?? 0,
    );
  }
}

class TeamImage {
  int teamImageId;
  String teamImageUrl;

  TeamImage({required this.teamImageId, required this.teamImageUrl});

  factory TeamImage.fromJson(Map<String, dynamic> json) {
    return TeamImage(
      teamImageId: json['teamImageId'] as int,
      teamImageUrl: json['imageUrl'] as String,
    );
  }
}
