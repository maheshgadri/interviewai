import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the form page after a delay
    Future.delayed(Duration(seconds: 2), () {
      Get.offNamed('/welcome'); // Navigate to the FormPage route
    });
  }

  @override
  Widget build(BuildContext context) {
    // You can customize the splash screen UI here
    return Scaffold(
      body: Center(
          child: Image.asset('assets/logo.png'), // Display a loading indicator
      ),
    );
  }
}