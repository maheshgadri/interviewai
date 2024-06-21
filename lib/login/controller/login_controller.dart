import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:interviewai/constants/api_consts.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isLoading = false.obs;

  void login() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      isLoading.value = true; // Set loading to true during login process

      try {
        final response = await http.post(
          Uri.parse('$NGROK/login/login'), // Replace with your API endpoint
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': emailController.text,
            'password': passwordController.text,
          }),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          if (responseData['success'] == true) {
            isLoading.value = false; // Set loading to false after successful login

            // Navigate to HomeScreen and pass user data
            Get.offAllNamed('/form', arguments: {
              'id': responseData['user']['id'],
              'username': responseData['user']['username'],
              'email': responseData['user']['email']
            });
          } else {
            isLoading.value = false; // Set loading to false if login failed
            Get.snackbar('Error', responseData['error'],
                snackPosition: SnackPosition.BOTTOM);
          }
        } else {
          isLoading.value = false; // Set loading to false if server error occurred
          Get.snackbar('Error', 'Server error',
              snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        isLoading.value = false; // Set loading to false if an exception occurred
        print('Exception occurred: $e');
        Get.snackbar('Error', 'An error occurred',
            snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Get.snackbar('Error', 'Please enter email and password',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}

// class LoginController extends GetxController {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final RxBool isLoading = false.obs;
//
//   void login() async {
//     if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
//       isLoading.value = true; // Set loading to true during login process
//
//       try {
//         final response = await http.post(
//           Uri.parse('https://17da-202-179-91-72.ngrok-free.app/login/login'), // Replace with your API endpoint
//           headers: <String, String>{
//             'Content-Type': 'application/json; charset=UTF-8',
//           },
//           body: jsonEncode(<String, String>{
//             'email': emailController.text,
//             'password': passwordController.text,
//           }),
//         );
//
//         if (response.statusCode == 200) {
//           final Map<String, dynamic> responseData = json.decode(response.body);
//           if (responseData['success'] == true) {
//             isLoading.value = false; // Set loading to false after successful login
//             // Navigate to HomeScreen
//             Get.offAllNamed('/home');
//           } else {
//             isLoading.value = false; // Set loading to false if login failed
//             Get.snackbar('Error', responseData['error'],
//                 snackPosition: SnackPosition.BOTTOM);
//           }
//         } else {
//           isLoading.value = false; // Set loading to false if server error occurred
//           Get.snackbar('Error', 'Server error',
//               snackPosition: SnackPosition.BOTTOM);
//         }
//       } catch (e) {
//         isLoading.value = false; // Set loading to false if an exception occurred
//         print('Exception occurred: $e');
//         Get.snackbar('Error', 'An error occurred',
//             snackPosition: SnackPosition.BOTTOM);
//       }
//     } else {
//       Get.snackbar('Error', 'Please enter email and password',
//           snackPosition: SnackPosition.BOTTOM);
//     }
//   }
// }

// class LoginController extends GetxController {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final RxBool isLoading = false.obs;
//
//   void login() async {
//     String email = emailController.text;
//     String password = passwordController.text;
//
//     if (email.isNotEmpty && password.isNotEmpty) {
//       isLoading.value = true;
//
//       try {
//         var url = Uri.parse('https://be73-202-179-91-72.ngrok-free.app/login');
//
//         // Encode the data as JSON
//         var body = json.encode({'email': email, 'password': password});
//
//         var response = await http.post(
//           url,
//           headers: {
//             'Content-Type': 'application/json', // Set the content type to JSON
//           },
//           body: body,
//         );
//
//         if (response.statusCode == 200) {
//           // Success
//           isLoading.value = false;
//           // Navigate to HomeScreen
//           Get.offAllNamed('/home');
//         } else {
//           // Error
//           isLoading.value = false;
//           Get.snackbar('Error', 'Failed to register user');
//         }
//       } catch (e) {
//         print('Error: $e');
//         isLoading.value = false;
//         Get.snackbar('Error', 'Failed to connect to server');
//       }
//     } else {
//       Get.snackbar('Error', 'Please enter email and password',
//           snackPosition: SnackPosition.BOTTOM);
//     }
//   }
// }
