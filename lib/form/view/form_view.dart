import 'package:flutter/material.dart';
import 'package:interviewai/common/common_widget.dart';
import 'package:interviewai/form/controller/form_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final FormController _controller = Get.put(FormController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late String username;
  late int id;
  late TextEditingController firstNameController;

  @override
  void initState() {
    super.initState();
    // Retrieve the arguments passed from the login page
    final args = Get.arguments;
    username = args['username'];
    id = args['id'];

    // Initialize the TextEditingController with the username value
    firstNameController = TextEditingController(text: username);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('User ID: $id'),
                Text('Username: $username'),
                TextFormField(
                  controller: firstNameController, // Set the controller
                  decoration: InputDecoration(labelText: 'First Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _controller.formData.firstName = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Last Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _controller.formData.lastName = value!;
                  },
                ),
                DropdownButtonFormField<String>(
                  items: ['Android Developer', 'Digital Marketing', 'Designer']
                      .map((String designation) {
                    return DropdownMenuItem<String>(
                      value: designation,
                      child: Text(designation),
                    );
                  }).toList(),
                  onChanged: (value) {
                    _controller.formData.designation = value!;
                  },
                  decoration: InputDecoration(labelText: 'Designation'),
                ),
                DropdownButtonFormField<String>(
                  items: ['IT', 'Finance', 'Healthcare', 'Software Industry']
                      .map((String industry) {
                    return DropdownMenuItem<String>(
                      value: industry,
                      child: Text(industry),
                    );
                  }).toList(),
                  onChanged: (value) {
                    _controller.formData.industry = value!;
                  },
                  decoration: InputDecoration(labelText: 'Industry'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Years of Experience'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your years of experience';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _controller.formData.yearsOfExperience = value!;
                  },
                ),
                SizedBox(height: 20),
                Center(
                  child: _isLoading
                      ? CircularProgressIndicator() // Show progress indicator if loading
                      : ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        setState(() {
                          _isLoading = true; // Set loading state to true
                        });
                        _controller.submitForm( id).then((_) {
                          setState(() {
                            _isLoading = false; // Set loading state to false after completing form submission
                          });
                        });
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
