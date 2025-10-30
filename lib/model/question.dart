class Question {
  final String id;
  final String userId;
  final String date;
  final String time;
  final String description;
  final String? answer;
  final String? answeredByUserId;
  final String? answerDate;
  final String? answerTime;
  final DateTime? timestamp;

  Question({
    required this.id,
    required this.userId,
    required this.date,
    required this.time,
    required this.description,
    this.answer,
    this.answeredByUserId,
    this.answerDate,
    this.answerTime,
    this.timestamp,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? '',
      userId: json['userId']?.toString() ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      description: json['description'] ?? '',
      answer: json['answer'],
      answeredByUserId: json['answeredByUserId']?.toString(),
      answerDate: json['answerDate'],
      answerTime: json['answerTime'],
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'date': date,
      'time': time,
      'description': description,
      'answer': answer,
      'answeredByUserId': answeredByUserId,
      'answerDate': answerDate,
      'answerTime': answerTime,
      'timestamp': (timestamp ?? DateTime.now()).toIso8601String(),
    };
  }

  Question copyWith({
    String? id,
    String? userId,
    String? date,
    String? time,
    String? description,
    String? answer,
    String? answeredByUserId,
    String? answerDate,
    String? answerTime,
    DateTime? timestamp,
  }) {
    return Question(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      time: time ?? this.time,
      description: description ?? this.description,
      answer: answer ?? this.answer,
      answeredByUserId: answeredByUserId ?? this.answeredByUserId,
      answerDate: answerDate ?? this.answerDate,
      answerTime: answerTime ?? this.answerTime,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}