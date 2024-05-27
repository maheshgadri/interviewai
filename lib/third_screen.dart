// import 'package:flutter/material.dart';
// import 'package:interviewai/API/model/ChatModel.dart';
// import 'package:interviewai/API/view/ApiService.dart';
//
// class ThirdScreen extends StatefulWidget {
//   final String firstName;
//   final String lastName;
//   final String designation;
//   final String industry;
//   final String yearsOfExperience;
//
//   ThirdScreen({
//     required this.firstName,
//     required this.lastName,
//     required this.designation,
//     required this.industry,
//     required this.yearsOfExperience,
//   });
//
//   @override
//   _ThirdScreenState createState() => _ThirdScreenState();
// }
//
// class _ThirdScreenState extends State<ThirdScreen> {
//   List<ChatModel> mcqs = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchMCQs();
//   }
//
//   // void fetchMCQs() async {
//   //   try {
//   //     // Fetch MCQs using the ApiService
//   //     mcqs = await ApiService.sendMessageGPT(
//   //       message: "Generate 10 multiple-choice questions with answers.",
//   //       modelId: "gpt-3.5-turbo-0301", // Replace with your model ID
//   //     );
//   //
//   //     setState(() {}); // Update the UI with fetched MCQs
//   //   } catch (error) {
//   //     // Handle error
//   //     print("Error fetching MCQs: $error");
//   //   }
//   // }
//
//   void fetchMCQs() async {
//     try {
//       // Construct the prompt message including the details
//       String prompt = "Generate 10 multiple-choice questions with answers.\n";
//       // prompt += "First Name: ${widget.firstName}\n";
//       // prompt += "Last Name: ${widget.lastName}\n";
//       prompt += "Designation: ${widget.designation}\n";
//       prompt += "Industry: ${widget.industry}\n";
//       prompt += "Years of Experience: ${widget.yearsOfExperience}\n";
//
//       // Fetch MCQs using the ApiService
//       mcqs = await ApiService.sendMessageGPT(
//         message: prompt,
//         modelId: "gpt-3.5-turbo-0301", // Replace with your model ID
//       );
//
//       setState(() {}); // Update the UI with fetched MCQs
//     } catch (error) {
//       // Handle error
//       print("Error fetching MCQs: $error");
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Technical Round'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('First Name: ${widget.firstName}'),
//             Text('Last Name: ${widget.lastName}'),
//             Text('Designation: ${widget.designation}'),
//             Text('Industry: ${widget.industry}'),
//             Text('Years of Experience: ${widget.yearsOfExperience}'),
//             SizedBox(height: 20),
//             Text(
//               'Multiple Choice Questions:',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: mcqs.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text('${index + 1}. ${mcqs[index].msg}'),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:interviewai/API/model/ChatModel.dart';
import 'package:interviewai/API/view/ApiService.dart';

class ThirdScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String designation;
  final String industry;
  final String yearsOfExperience;

  ThirdScreen({
    required this.firstName,
    required this.lastName,
    required this.designation,
    required this.industry,
    required this.yearsOfExperience,
  });

  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  List<ChatModel> mcqs = [];

  @override
  void initState() {
    super.initState();
    fetchMCQs();
  }

  void fetchMCQs() async {
    try {
      String prompt = "Generate 10 multiple-choice questions with answers.\n";
      prompt += "Designation: ${widget.designation}\n";
      prompt += "Industry: ${widget.industry}\n";
      prompt += "Years of Experience: ${widget.yearsOfExperience}\n";

      // Fetch MCQs using the ApiService
      mcqs = await ApiService.sendMessageGPT(
        message: prompt,
        modelId: "gpt-3.5-turbo-0301",
      );

      setState(() {});
      insertMCQsIntoDatabase(mcqs);
    } catch (error) {
      print("Error fetching MCQs: $error");
    }
  }
  void insertMCQsIntoDatabase(List<ChatModel> mcqs) async {
    final String apiUrl = 'https://cc64-202-179-91-72.ngrok-free.app/des_open_ai_response/saveResponses';

    try {
      for (ChatModel chatModel in mcqs) {
        final responseText = chatModel.msg.trim();
        // Split the response into individual questions (assuming '\n' separates the questions)
        List<String> questions = responseText.split('\n\n');

        for (String questionBlock in questions) {
          if (questionBlock.isEmpty) continue;

          // Parse the question block to extract the question, options, and answer
          final lines = questionBlock.split('\n');
          if (lines.length < 5) continue; // Ensure there are at least 5 lines (1 question, 4 options, 1 answer)

          final questionText = lines[0].trim();
          final options = lines.sublist(1, 5).map((line) => line.trim()).toList();
          final answer = lines[5].replaceFirst('Answer: ', '').trim();

          final httpResponse = await http.post(
            Uri.parse(apiUrl),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'question_text': questionText,
              'options': options,
              'answer': answer,
            }),
          );

          final responseData = jsonDecode(httpResponse.body);

          if (httpResponse.statusCode == 200) {
            print('Question "$questionText" saved successfully');
          } else {
            print('Failed to save question "$questionText". Error: ${responseData['error']}');
          }
        }
      }
    } catch (e) {
      print('Failed to connect to the server. Error: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Technical Round'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('First Name: ${widget.firstName}'),
            Text('Last Name: ${widget.lastName}'),
            Text('Designation: ${widget.designation}'),
            Text('Industry: ${widget.industry}'),
            Text('Years of Experience: ${widget.yearsOfExperience}'),
            SizedBox(height: 20),
            Text(
              'Multiple Choice Questions:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: mcqs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${index + 1}. ${mcqs[index].msg}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}