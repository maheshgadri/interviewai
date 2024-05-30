import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interviewai/login/view/login_screen.dart';

import '../login/view/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Welcome to Smart Travel'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/login'); // Navigate to login screen
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/signup'); // Navigate to sign up screen
              },
              child: const Text('SignUp'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // _launchURL('https://your-terms-and-conditions-url.com');
              },
              child: const Text(
                'Terms and Conditions',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // _launchURL('https://your-privacy-policy-url.com');
              },
              child: const Text(
                'Privacy Policy',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// void _launchURL(String url) async {
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     throw 'Could not launch $url';
//   }
// }
}
