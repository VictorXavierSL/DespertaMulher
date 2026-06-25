import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/quiz_page_response.dart';

class QuizServer {
  Future<QuizPageResponse> fetchQuestions(int page) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final jsonString =
        await rootBundle.loadString('assets/Mock/page$page.json');
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return QuizPageResponse.fromJson(json);
  }
}
