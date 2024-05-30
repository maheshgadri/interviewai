import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interviewai/form/view/form_view.dart';
import 'package:interviewai/intchat/view/intcha.dart';
import 'package:interviewai/login/controller/login_controller.dart';
import 'package:interviewai/splash_screen.dart';
import 'package:interviewai/welcom_screen.dart';

import 'login/controller/signup_controller.dart';
import 'login/view/login_screen.dart';
import 'login/view/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        getPages: [
          GetPage(name: '/', page: () => SplashScreen()),
          GetPage(
            name: '/welcome',
            page: () => WelcomeScreen(),
          ),
          GetPage(
            name: '/login',
            page: () {
              // Initialize LoginController here
              Get.put(LoginController());
              return LoginScreen();
            },
          ),
          GetPage(
            name: '/signup',
            page: () {
              // Initialize LoginController here
              Get.put(SignUpController());
              return SignUpView();
            },
          ),
          GetPage(name: '/form', page: () => FormPage()),
          GetPage(name: '/chat', page: () => ChatScreen(messages: [])), // Dummy initial messages
        ]
    );
  }
}

