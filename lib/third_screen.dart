import 'package:flutter/material.dart';

class ThirdScreen extends StatelessWidget {
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
            Text('First Name: $firstName'),
            Text('Last Name: $lastName'),
            Text('Designation: $designation'),
            Text('Industry: $industry'),
            Text('Years of Experience: $yearsOfExperience'),
          ],
        ),
      ),
    );
  }
}
