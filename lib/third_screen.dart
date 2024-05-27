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

  // void fetchMCQs() async {
  //   try {
  //     // Fetch MCQs using the ApiService
  //     mcqs = await ApiService.sendMessageGPT(
  //       message: "Generate 10 multiple-choice questions with answers.",
  //       modelId: "gpt-3.5-turbo-0301", // Replace with your model ID
  //     );
  //
  //     setState(() {}); // Update the UI with fetched MCQs
  //   } catch (error) {
  //     // Handle error
  //     print("Error fetching MCQs: $error");
  //   }
  // }

  void fetchMCQs() async {
    try {
      // Construct the prompt message including the details
      String prompt = "Generate 10 multiple-choice questions with answers.\n";
      // prompt += "First Name: ${widget.firstName}\n";
      // prompt += "Last Name: ${widget.lastName}\n";
      prompt += "Designation: ${widget.designation}\n";
      prompt += "Industry: ${widget.industry}\n";
      prompt += "Years of Experience: ${widget.yearsOfExperience}\n";

      // Fetch MCQs using the ApiService
      mcqs = await ApiService.sendMessageGPT(
        message: prompt,
        modelId: "gpt-3.5-turbo-0301", // Replace with your model ID
      );

      setState(() {}); // Update the UI with fetched MCQs
    } catch (error) {
      // Handle error
      print("Error fetching MCQs: $error");
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
