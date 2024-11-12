// class Task {
//   final int taskID;
//   final String name;
//   final String description;
//   final bool withMsg;
//   final int adminIDAPI;
//   final List<String> taskFreeTexts;
//   final QuestionTask? questionTask;
//   final List<Media> mediaList;

//   Task({
//     required this.taskID,
//     required this.name,
//     required this.description,
//     required this.withMsg,
//     required this.adminIDAPI,
//     required this.taskFreeTexts,
//     required this.questionTask,
//     required this.mediaList,
//   });

//   factory Task.fromJson(Map<String, dynamic> json) {
//     return Task(
//       taskID: json['taskID'],
//       name: json['name'],
//       description: json['description'],
//       withMsg: json['withMsg'],
//       adminIDAPI: json['adminIDAPI'],
//       taskFreeTexts: List<String>.from(json['taskFreeTexts']),
//       questionTask: json['questionTask'] != null
//           ? QuestionTask.fromJson(json['questionTask'])
//           : null,
//       mediaList: List<Media>.from(json['mediaList'].map((x) => Media.fromJson(x))),
//     );
//   }
// }

// class QuestionTask {
//   final int questionTaskID;
//   final String question;
//   final List<String> answers;
//   final int correctAnswer;

//   QuestionTask({
//     required this.questionTaskID,
//     required this.question,
//     required this.answers,
//     required this.correctAnswer,
//   });

//   factory QuestionTask.fromJson(Map<String, dynamic> json) {
//     return QuestionTask(
//       questionTaskID: json['questionTaskID'],
//       question: json['question'],
//       answers: List<String>.from(json['answers']),
//       correctAnswer: json['correctAnswer'],
//     );
//   }
// }

// class Media {
//   final int mediaTaskID;
//   final String fileName;
//   final String mediaPath;
//   final String mediaType;
//   final String mediaUrl;

//   Media({
//     required this.mediaTaskID,
//     required this.fileName,
//     required this.mediaPath,
//     required this.mediaType,
//     required this.mediaUrl,
//   });

//   factory Media.fromJson(Map<String, dynamic> json) {
//     return Media(
//       mediaTaskID: json['mediaTaskID'],
//       fileName: json['fileName'],
//       mediaPath: json['mediaPath'],
//       mediaType: json['mediaType'],
//       mediaUrl: json['mediaUrl'],
//     );
//   }
// }
class Game {
  final int gameID;
  final String gameName;
  final List<Unit> units;
  final String qrcodeURL;

  Game({
    required this.gameID,
    required this.gameName,
    required this.units,
    required this.qrcodeURL,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      gameID: json['gameID'],
      gameName: json['gameName'],
      units: List<Unit>.from(json['units'].map((x) => Unit.fromJson(x))),
      qrcodeURL: json['qrcodeURL'],
    );
  }
}

class Unit {
  final int unitID;
  final String name;
  final String hint;
  final int unitOrder;
  final Task taskDTO;
  final LocationDTO locationDTO;
  final ObjectDTO objectDTO;

  Unit({
    required this.unitID,
    required this.name,
    required this.hint,
    required this.unitOrder,
    required this.taskDTO,
    required this.locationDTO,
    required this.objectDTO,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      unitID: json['unitID'],
      name: json['name'],
      hint: json['hint'],
      unitOrder: json['unitOrder'],
      taskDTO: Task.fromJson(json['taskDTO']),
      locationDTO: LocationDTO.fromJson(json['locationDTO']),
      objectDTO: ObjectDTO.fromJson(json['objectDTO']),
    );
  }
}

class Task {
  final int taskID;
  final String name;
  final bool withMsg;
  final List<String> taskFreeTexts;
  final QuestionTask? questionTask;
  final List<Media> mediaList;

  Task({
    required this.taskID,
    required this.name,
    required this.withMsg,
    required this.taskFreeTexts,
    required this.questionTask,
    required this.mediaList,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskID: json['taskID'],
      name: json['name'],
      withMsg: json['withMsg'],
      taskFreeTexts: List<String>.from(json['taskFreeTexts']),
      questionTask: json['questionTask'] != null
          ? QuestionTask.fromJson(json['questionTask'])
          : null,
      mediaList: List<Media>.from(json['mediaList'].map((x) => Media.fromJson(x))),
    );
  }
}

class QuestionTask {
  final int questionTaskID;
  final String question;
  final List<String> answers;
  final int correctAnswer;

  QuestionTask({
    required this.questionTaskID,
    required this.question,
    required this.answers,
    required this.correctAnswer,
  });

  factory QuestionTask.fromJson(Map<String, dynamic> json) {
    return QuestionTask(
      questionTaskID: json['questionTaskID'],
      question: json['question'],
      answers: List<String>.from(json['answers']),
      correctAnswer: json['correctAnswer'],
    );
  }
}

class Media {
  final int mediaTaskID;
  final String mediaType;
  final String mediaUrl;

  Media({
    required this.mediaTaskID,
    required this.mediaType,
    required this.mediaUrl,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      mediaTaskID: json['mediaTaskID'],
      mediaType: json['mediaType'],
      mediaUrl: json['mediaUrl'],
    );
  }
}

class LocationDTO {
  final int locationID;
  final String name;
  final int floor;
  final String? locationImagePublicUrl;
  final String qrcodePublicUrl;

  LocationDTO({
    required this.locationID,
    required this.name,
    required this.floor,
    this.locationImagePublicUrl,
    required this.qrcodePublicUrl,
  });

  factory LocationDTO.fromJson(Map<String, dynamic> json) {
    return LocationDTO(
      locationID: json['locationID'],
      name: json['name'],
      floor: json['floor'],
      locationImagePublicUrl: json['locationImagePublicUrl'],
      qrcodePublicUrl: json['qrcodePublicUrl'],
    );
  }
}

class ObjectDTO {
  final int objectID;
  final String name;

  ObjectDTO({
    required this.objectID,
    required this.name,
  });

  factory ObjectDTO.fromJson(Map<String, dynamic> json) {
    return ObjectDTO(
      objectID: json['objectID'],
      name: json['name'],
    );
  }
}

