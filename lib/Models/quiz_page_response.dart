import 'question.dart';

class QuizPageResponse {
  final int page;
  final int lastPage;
  final List<Question> questions;

  QuizPageResponse({
    required this.page,
    required this.lastPage,
    required this.questions,
  });

  factory QuizPageResponse.fromJson(Map<String, dynamic> json) =>
      QuizPageResponse(
        page: json['page'] as int,
        lastPage: json['lastPage'] as int,
        questions: (json['questions'] as List)
            .map((e) => Question.fromJson(e))
            .toList(),
      );
}
