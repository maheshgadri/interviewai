import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:interviewai/login/controller/login_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends GetView<LoginController> {
  final _obscureText = true.obs; // Observable to toggle password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => TextFormField(
              controller: controller.passwordController,
              obscureText: _obscureText.value, // Toggle visibility based on _obscureText value
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
                suffixIcon: GestureDetector(
                  onTap: () {
                    // Toggle password visibility
                    _obscureText.value = !_obscureText.value;
                  },
                  child: Icon(
                    _obscureText.value ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                ),
              ),
            )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.login,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Obx(() => controller.isLoading.value
                  ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
                  : const Text('Login', style: TextStyle(fontSize: 16))),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Get.toNamed('/forgot_password');
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Implement Google login
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Login with Google'),
            ),
          ],
        ),
      ),
    );
  }
}


