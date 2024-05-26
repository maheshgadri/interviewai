import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interviewai/form/view/form_view.dart';
import 'package:interviewai/intchat/view/intcha.dart';

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
        getPages: [

          GetPage(name: '/', page: () => FormPage()),
          GetPage(name: '/chat', page: () => ChatScreen(messages: [])), // Dummy initial messages
        ]
    );
  }
}
