/*
Nome: CreateMaterialApp()
Descrição: Cria o objeto MaterialApp com as rotas e suas respectivas classes
Autor: Silvano Malfatti
Data: 13/06/2026
 */

import 'package:flutter/material.dart';
import '../Screens/Quiz/quiz_page.dart';
import '../Screens/login/login_page.dart';
import '../Screens/photo/photo_page.dart';
import '../Screens/profile/profile_page.dart';
import '../Screens/registration/register_page.dart';
import '../Screens/result/result_page.dart';
import 'app_routes.dart';

Widget createMaterialApp() {
  return MaterialApp(
    initialRoute: AppRoutes.quizPage,
    routes: {
      AppRoutes.loginPage: (_) => LoginPage(),
      AppRoutes.profilePage: (_) => ProfilePage(),
      AppRoutes.registerPage: (_) => RegisterPage(),
      AppRoutes.photoPage: (_) => SelectPhotoPage(),
      AppRoutes.quizPage: (_) => QuizPage(),
      AppRoutes.resultPage: (_) => ResultPage()}
  );
}