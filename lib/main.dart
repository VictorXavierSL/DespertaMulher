import 'package:flutter/material.dart';
import 'common/app_routes.dart';
import 'screens/quiz/quiz_page.dart';
import 'screens/result/result_page.dart';

void main() => runApp(_createApp());

Widget _createApp() {
  return MaterialApp(
    title: 'Desperta Mulher',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Roboto',
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFAD1457)),
      useMaterial3: true,
    ),
    initialRoute: AppRoutes.quiz,
    routes: {
      AppRoutes.quiz:   (_) => const QuizPage(),
      AppRoutes.result: (_) => const ResultPage(),
    },
  );
}
