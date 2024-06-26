

import 'package:interviewai/API/model/ChatModel.dart';
import 'package:interviewai/API/view/ApiService.dart';
import 'package:interviewai/intchat/view/intcha.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/form_model.dart';


// class FormController {
//   FormData formData = FormData();
//
//
//   void submitForm() {
//     // Here you can implement logic to submit the form data
//     print('Form submitted!');
//     print('First Name: ${formData.firstName}');
//     print('Last Name: ${formData.lastName}');
//     print('Designation: ${formData.designation}');
//     print('Industry: ${formData.industry}');
//     print('Years of Experience: ${formData.yearsOfExperience}');
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:interviewai/form/model/form_model.dart' as InteForm;

// class FormController extends GetxController {
//   final InteForm.FormData formData = InteForm.FormData(); // Instance of FormData
//
//   Future<void> submitForm(int id) async {
//
//     // Inside submitForm() method in FormController
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('firstName', formData.firstName);
//     prefs.setString('lastName', formData.lastName);
//     prefs.setString('designation', formData.designation);
//     prefs.setString('industry', formData.industry);
//     prefs.setString('yearsOfExperience', formData.yearsOfExperience);
//
//     // Prepare data to send to ChatGPT
//     String prompt =
//         'First Name: ${formData.firstName}\n'
//         'Last Name: ${formData.lastName}\n'
//         'Designation: ${formData.designation}\n'
//         'Industry: ${formData.industry}\n'
//         'Years of Experience: ${formData.yearsOfExperience}\n'
//         'greet candidate with short note chatbot chat dont include Thank you and looking forward to hearing back from you, Best regards, etc and ask about the project';
//
//     try {
//       // Send data to ChatGPT and handle responses
//       List<ChatModel> responses = await ApiService.sendMessage(
//         message: prompt,
//         modelId: 'gpt-3.5-turbo-0301',
//       );
//
//       // Extract messages from responses
//       List<String> messages = responses.map((e) => e.msg).toList();
//
//       // Print OpenAI response
//       print('OpenAI Response:');
//       messages.forEach((message) {
//         print(message);
//       });
//
//       // Navigate to chat screen with form data and responses
//       Get.to(() => ChatScreen(messages: messages,id: id));
//     } catch (e) {
//       // Handle errors
//       Get.dialog(
//         AlertDialog(
//           title: Text("Error"),
//           content: Text(e.toString()),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Get.back();
//               },
//               child: Text("OK"),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }



// class FormController extends GetxController {
//   // final FormData formData = FormData();
//   final InteForm.FormData formData = InteForm.FormData();
//   Future<void> submitForm(int id) async {
//     // Prepare data to send to ChatGPT
//     String prompt =
//     // 'First Name: ${formData.firstName}\n'
//     // 'Last Name: ${formData.lastName}\n'
//     // 'Designation: ${formData.designation}\n'
//     // 'Industry: ${formData.industry}\n'
//     // 'Years of Experience: ${formData.yearsOfExperience}\n'
//         'Document Text: ${formData.uploadedFileText}\n'
//         'Extract first name , last name , years of expereince in numbers,designation from the extracted text and Greet candidate with short note of 30 words. Don\'t include "Thank you" and "Looking forward to hearing back from you", "Best regards", etc. Ask about the project.';
//
//     try {
//       // Send data to ChatGPT and handle responses
//       List<ChatModel> responses = await ApiService.sendMessage(
//         message: prompt,
//         modelId: 'gpt-3.5-turbo-0301',
//       );
//
//       // Extract messages from responses
//       List<String> messages = responses.map((e) => e.msg).toList();
//
//       // Print OpenAI response
//       print('OpenAI Response:');
//       messages.forEach((message) {
//         print(message);
//       });
//
//       // Navigate to chat screen with form data and responses
//       Get.to(() => ChatScreen(messages: messages,id: id));
//     } catch (e) {
//       // Handle errors
//       Get.dialog(
//         AlertDialog(
//           title: Text("Error"),
//           content: Text(e.toString()),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Get.back();
//               },
//               child: Text("OK"),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }

class FormController extends GetxController {
  final InteForm.FormData formData = InteForm.FormData();

  Future<void> submitForm(int id) async {
    // Prepare data to send to ChatGPT
    String prompt =
        'Document Text: ${formData.uploadedFileText}\n'
        'Extract first name, last name, always converts years of experience in numbers, designation from the extracted text and greet the candidate with a short note of 30 words. Don\'t include "Thank you" and "Looking forward to hearing back from you", "Best regards", etc. Ask about the project.';

    try {
      // Send data to ChatGPT and handle responses
      List<ChatModel> responses = await ApiService.sendMessage(
        message: prompt,
        modelId: 'gpt-3.5-turbo-0301',
      );

      // Extract messages from responses
      List<String> messages = responses.map((e) => e.msg).toList();

      // Print OpenAI response and extract required details
      print('OpenAI Response:');
      String? firstName, lastName, designation, yearsOfExperience;

      messages.forEach((message) {
        print(message);

        // Extract details from the response message
        RegExp firstNameExp = RegExp(r'First name: (\w+)', caseSensitive: false);
        RegExp lastNameExp = RegExp(r'Last name: (\w+)', caseSensitive: false);
        RegExp designationExp = RegExp(r'Designation: (.+)', caseSensitive: false);
        RegExp yearsExp = RegExp(r'Years of experience: (\w+)', caseSensitive: false);

        // Try to extract each piece of information
        if (firstName == null) {
          var match = firstNameExp.firstMatch(message);
          if (match != null) {
            firstName = match.group(1);
          }
        }
        if (lastName == null) {
          var match = lastNameExp.firstMatch(message);
          if (match != null) {
            lastName = match.group(1);
          }
        }
        if (designation == null) {
          var match = designationExp.firstMatch(message);
          if (match != null) {
            designation = match.group(1);
          }
        }
        if (yearsOfExperience == null) {
          var match = yearsExp.firstMatch(message);
          if (match != null) {
            yearsOfExperience = match.group(1);
          }
        }
      });

      // Log extracted data to verify
      print('Extracted Data:');
      print('First Name: $firstName');
      print('Last Name: $lastName');
      print('Designation: $designation');
      print('Years of Experience: $yearsOfExperience');

      // Handle cases where data might be missing or not extracted correctly
      if (firstName == null || lastName == null || designation == null || yearsOfExperience == null) {
        throw Exception('Failed to extract all required information from OpenAI response');
      }

      // Save details to shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstName', firstName!);
      await prefs.setString('lastName', lastName!);
      await prefs.setString('designation', designation!);
      await prefs.setString('yearsOfExperience', yearsOfExperience!);

      // Navigate to chat screen with form data and responses
      Get.to(() => ChatScreen(messages: messages, id: id));
    } catch (e) {
      // Handle errors
      Get.dialog(
        AlertDialog(
          title: Text("Error"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }
}
