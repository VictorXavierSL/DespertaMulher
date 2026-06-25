/*
Nome: QuizPageResponse
Descrição: classe responsável pelo parsing de uma página de perguntas
Autor: Silvano Malfatti
Data: 13/06/2026
 */

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

  factory QuizPageResponse.fromJson(Map<String, dynamic> json) {
    return QuizPageResponse(
      page: json['page'] as int,
      lastPage: json['lastPage'] as int,
      questions: (json['questions'] as List)
          .map((e) => Question.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'lastPage': lastPage,
      'questions': questions.map((e) => e.toJson()).toList(),
    };
  }
}
