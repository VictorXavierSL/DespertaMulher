class Answer {
  final String title;
  final int score;

  const Answer({required this.title, required this.score});

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        title: json['title'] as String? ?? '',
        score: json['score'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {'title': title, 'score': score};

  @override
  bool operator ==(Object other) =>
      other is Answer && other.title == title && other.score == score;

  @override
  int get hashCode => Object.hash(title, score);
}
