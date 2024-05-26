import 'package:flutter/material.dart';
import 'package:interviewai/form/controller/form_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final FormController _controller = Get.put(FormController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
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
                items: ['Android Developer','Digital Marketing', 'Designer']
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
                items: ['IT', 'Finance', 'Healthcare','Software Industry']
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
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _controller.submitForm();
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

