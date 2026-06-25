import 'answer.dart';

class Question {
  final String title;
  final List<Answer> answers;
  final bool multipleChoice;

  Answer? selectedAnswer;
  final List<Answer> selectedAnswers = [];

  Question({
    required this.title,
    required this.answers,
    required this.multipleChoice,
    this.selectedAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        title: json['title'] as String,
        multipleChoice: json['multipleChoice'] as bool? ?? false,
        answers: (json['answers'] as List)
            .map((e) => Answer.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'multipleChoice': multipleChoice,
        'answers': answers.map((e) => e.toJson()).toList(),
      };

  bool isSelected(Answer answer) => multipleChoice
      ? selectedAnswers.contains(answer)
      : selectedAnswer == answer;

  void toggleAnswer(Answer answer) {
    if (multipleChoice) {
      selectedAnswers.contains(answer)
          ? selectedAnswers.remove(answer)
          : selectedAnswers.add(answer);
    } else {
      selectedAnswer = answer;
    }
  }

  int get totalScore {
    if (multipleChoice) {
      return selectedAnswers.fold(0, (sum, a) => sum + a.score);
    }
    return selectedAnswer?.score ?? 0;
  }
}
