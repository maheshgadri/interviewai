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

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:interviewai/API/model/ChatModel.dart';
import 'package:interviewai/API/view/ApiService.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:interviewai/API/model/ChatModel.dart';
import 'package:interviewai/API/view/ApiService.dart';
import 'package:interviewai/common/common_widget.dart';
import 'package:interviewai/constants/api_consts.dart';

class ThirdScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String designation;
  final String industry;
  final String yearsOfExperience;
  final int id;

  ThirdScreen({
    required this.firstName,
    required this.lastName,
    required this.designation,
    required this.industry,
    required this.yearsOfExperience,
    required this.id,
  });

  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  List<ChatModel> mcqs = [];
  bool _isFetching = false;
  StreamController<List<Map<String, dynamic>>> _controller = StreamController<
      List<Map<String, dynamic>>>();
  Map<int, int> _selectedAnswers = {}; // Map to keep track of selected answers

  @override
  void initState() {
    super.initState();
    print('ID>>init: ${widget.id}');
    fetchMCQs();
    Timer.periodic(Duration(seconds: 15), (timer) {
      if (!_isFetching) {
        fetchResponses(widget.id);
      }
    });
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

      print("mcq>> $mcqs");
      setState(() {});
      insertMCQsIntoDatabase(mcqs,widget.id);
    } catch (error) {
      print("Error fetching MCQs: $error");
    }
  }

  // void insertMCQsIntoDatabase(List<ChatModel> mcqs) async {
  //   final String apiUrl = '$NGROK/des_open_ai_response/saveResponses';
  //
  //   try {
  //     for (ChatModel chatModel in mcqs) {
  //       final responseText = chatModel.msg.trim();
  //       // Split the response into individual questions (assuming '\n\n' separates the questions)
  //       List<String> questions = responseText.split('\n\n');
  //
  //       for (String questionBlock in questions) {
  //         if (questionBlock.isEmpty) continue;
  //
  //         // Parse the question block to extract the question, options, and answer
  //         final lines = questionBlock.split('\n');
  //         if (lines.length < 5)
  //           continue; // Ensure there are at least 5 lines (1 question, 4 options, 1 answer)
  //
  //         final questionText = lines[0].trim();
  //         final options = lines.sublist(1, 5)
  //             .map((line) => line.trim())
  //             .toList();
  //         final answer = lines[5].replaceFirst('Answer: ', '').trim();
  //
  //         final httpResponse = await http.post(
  //           Uri.parse(apiUrl),
  //           headers: <String, String>{
  //             'Content-Type': 'application/json; charset=UTF-8',
  //           },
  //           body: jsonEncode(<String, dynamic>{
  //             'question_text': questionText,
  //             'options': options,
  //             'answer': answer,
  //           }),
  //         );
  //
  //         final responseData = jsonDecode(httpResponse.body);
  //
  //         if (httpResponse.statusCode == 200) {
  //           print('Question "$questionText" saved successfully');
  //         } else {
  //           print(
  //               'Failed to save question "$questionText". Error: ${responseData['error']}');
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     print('Failed to connect to the server. Error: $e');
  //   }
  // }
  void insertMCQsIntoDatabase(List<ChatModel> mcqs, int id) async {
    final String apiUrl = '$NGROK/des_open_ai_response/saveResponses';

    try {
      for (ChatModel chatModel in mcqs) {
        final responseText = chatModel.msg.trim();
        // Split the response into individual questions (assuming '\n\n' separates the questions)
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
              'user_id': id, // Add the id here
              'question_text': questionText,
              'option1': options[0],
              'option2': options[1],
              'option3': options[2],
              'option4': options[3],
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

  Future<void> fetchResponses(int userId) async {
    if (!_controller.isClosed) {
      _isFetching = true; // Set to true when fetching responses
      final String url = '$NGROK/fetch_route/responses?user_id=$userId'; // Use the userId parameter

      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          // If the server returns a successful response, parse the JSON
          List<dynamic> responseData = json.decode(response.body);

          // Add detailed logging to check the response structure
          print('Fetched Responses: $responseData');

          // Map each response part to a Map
          List<Map<String, dynamic>> mappedResponse = responseData.map((part) {
            print('Part: $part'); // Log each part to see the structure
            return {
              'id': part['id'],
              'question_text': part['question_text'],
              'options': [
                part['option1'],
                part['option2'],
                part['option3'],
                part['option4']
              ]
            };
          }).toList();

          _controller.add(mappedResponse);
        } else {
          // If the server returns an error response, throw an exception
          throw Exception('Failed to load responses: ${response.statusCode}');
        }
      } catch (error) {
        // If an error occurs during the HTTP request, throw an exception
        throw Exception('Failed to load responses: $error');
      } finally {
        _isFetching = false; // Set back to false after response is fetched
      }
    }
  }




  // Future<void> fetchResponses() async {
  //   if (!_controller.isClosed) {
  //     _isFetching = true; // Set to true when fetching responses
  //     final String url = '$NGROK/fetch_route/responses'; // Update the URL to match your server endpoint
  //
  //     try {
  //       final response = await http.get(Uri.parse(url));
  //
  //       if (response.statusCode == 200) {
  //         // If the server returns a successful response, parse the JSON
  //         List<dynamic> responseData = json.decode(response.body);
  //
  //         // Add detailed logging to check the response structure
  //         print('Fetched Responses: $responseData');
  //
  //         // Map each response part to a Map
  //         List<Map<String, dynamic>> mappedResponse = responseData.map((part) {
  //           print('Part: $part'); // Log each part to see the structure
  //           return {
  //             'cardIndex': part['cardIndex'],
  //             'question_text': part['question_text'],
  //             'options': [
  //               part['option1'],
  //               part['option2'],
  //               part['option3'],
  //               part['option4']
  //             ]
  //           };
  //         }).toList();
  //
  //         _controller.add(mappedResponse);
  //       } else {
  //         // If the server returns an error response, throw an exception
  //         throw Exception('Failed to load responses: ${response.statusCode}');
  //       }
  //     } catch (error) {
  //       // If an error occurs during the HTTP request, throw an exception
  //       throw Exception('Failed to load responses: $error');
  //     } finally {
  //       _isFetching = false; // Set back to false after response is fetched
  //     }
  //   }
  // }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  void saveUserResponse(user_id, int questionIndex, int selectedOption,
      List<String> options) async {
    final String apiUrl = '$NGROK/save_user_response/saveUserResponse'; // Replace with your server URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': user_id,
          // Combine first name and last name as user_id
          'question_id': questionIndex + 1,
          'selected_option': options[selectedOption],
          // Assuming question_id starts from 1
          // 'selected_option': selectedOption + 1, // Assuming options start from 1
        }),
      );

      if (response.statusCode == 200) {
        print('User response saved successfully');
      } else {
        print('Failed to save user response: ${response.body}');
      }
    } catch (error) {
      print('Failed to connect to the server: $error');
    }
  }

  Future<void> _fetchScore() async {
    final url = '$NGROK/score/score'; // Replace with your actual ngrok URL
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final message = jsonResponse['message'];
        print('Response message: $message');

        // Extract correct answers count and attempted questions count from the message
        final correctAnswersMatch = RegExp(r'Correct Answered Count: (\d+)').firstMatch(message);
        final attemptedQuestionsMatch = RegExp(r'Total Answered: (\d+)').firstMatch(message);
        final correctAnswers = correctAnswersMatch != null ? int.parse(correctAnswersMatch.group(1)!) : 0;
        final attemptedQuestions = attemptedQuestionsMatch != null ? int.parse(attemptedQuestionsMatch.group(1)!) : 0;

        // print('Correct Answers: $correctAnswers');
        // print('Attempted Questions: $attemptedQuestions');

        // Determine the message to display based on the number of correct answers
        String displayMessage;
        if (correctAnswers < 4) {
          displayMessage = 'You have not cleared the interview.\n\n';
        } else {
          displayMessage = 'You have cleared this round ';
        }

        displayMessage += '  '
            ' Correct Answers: $correctAnswers\nAttempted Questions: $attemptedQuestions\n\n$message';


        // Show the message in a dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Score'),
              content: Text(displayMessage),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        print('Failed to load score');
        // Handle error gracefully
        _showErrorDialog('Failed to load score');
      }
    } catch (e) {
      print('Error fetching score: $e');
      // Handle error gracefully
      _showErrorDialog('Error fetching score: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Future<void> _fetchScore() async {
  //   final url = '$NGROK/score/score'; // Replace with your actual ngrok URL
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //
  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       final message = jsonResponse['message'];
  //       print('Response message: $message');
  //       // You can show the message in a dialog or toast
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: Text('Score'),
  //             content: Text(message),
  //             actions: <Widget>[
  //               TextButton(
  //                 child: Text('OK'),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     } else {
  //       print('Failed to load score');
  //       // Handle error gracefully
  //     }
  //   } catch (e) {
  //     print('Error fetching score: $e');
  //     // Handle error gracefully
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    print('ID: ${widget.id}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Technical Round'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child:
              Card(

                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('First Name: ${widget.firstName}', style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('Last Name: ${widget.lastName}', style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('Designation: ${widget.designation}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('Industry: ${widget.industry}', style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('Years of Experience: ${widget.yearsOfExperience}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('id: ${widget.id}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                ),
              ),),
            SizedBox(height: 10),
            Text(
              'Multiple Choice Questions:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _controller.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No data available'));
                  } else {
                    var data = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              var questionData = data[index];
                              var questionText = questionData['question_text'];
                              var options = questionData['options'];

                              print('Question: $questionText');
                              print('Options: $options');

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${index + 1}. $questionText'),
                                  if (options != null && options is List &&
                                      options.isNotEmpty)
                                    ...options.map((option) {
                                      return RadioListTile<int>(
                                        title: Text(option),
                                        value: options.indexOf(option),
                                        groupValue: _selectedAnswers[index],
                                        onChanged: (int? value) {
                                          setState(() {
                                            _selectedAnswers[index] = value!;
                                            List<String> stringOptions = options
                                                .map((option) =>
                                                option.toString()).toList();
                                            saveUserResponse('1', index, value,
                                                stringOptions);
                                          });
                                        },
                                      );
                                    }).toList()
                                  else
                                    Text('No options available'),
                                  // Handle empty options gracefully
                                  SizedBox(height: 10),
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        // Add spacing between ListView.builder and the submit button
                        // Center(
                        //   child: SizedBox(
                        //     width: 200, // Set the desired width here
                        //     child: ElevatedButton(
                        //       onPressed: () {
                        //         _fetchScore();
                        //         // Add functionality to submit button
                        //       },
                        //       child: Text('Submit',style: TextStyle(
                        //           fontWeight: FontWeight.bold, fontSize: 18)),
                        //     ),
                        //   ),
                        // ),

                        Center(
                          child: CommonWidget(
                            text: 'Submit',
                            onPressed: () {
                                     _fetchScore();
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

