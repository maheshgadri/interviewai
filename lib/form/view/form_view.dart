import 'dart:io';

import 'package:flutter/material.dart';
import 'package:interviewai/common/common_widget.dart';
import 'package:interviewai/form/controller/form_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

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
  String? _uploadedFilePath;
  String? _pdfText;


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

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _uploadedFilePath = result.files.single.path;
      });
      _extractTextFromPdf(_uploadedFilePath!);
    }
  }

  Future<void> _extractTextFromPdf(String path) async {
    final PdfDocument document = PdfDocument(inputBytes: await File(path).readAsBytes());
    String text = PdfTextExtractor(document).extractText();
    document.dispose();

    setState(() {
      _pdfText = text;
    });

    _controller.formData.uploadedFileText = text;
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
                // TextFormField(
                //   controller: firstNameController, // Set the controller
                //   decoration: InputDecoration(labelText: 'First Name'),
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return 'Please enter your first name';
                //     }
                //     return null;
                //   },
                //   onSaved: (value) {
                //     _controller.formData.firstName = value!;
                //   },
                // ),
                // TextFormField(
                //   decoration: InputDecoration(labelText: 'Last Name'),
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return 'Please enter your last name';
                //     }
                //     return null;
                //   },
                //   onSaved: (value) {
                //     _controller.formData.lastName = value!;
                //   },
                // ),
                // DropdownButtonFormField<String>(
                //   items: ['Android Developer', 'Digital Marketing', 'Designer']
                //       .map((String designation) {
                //     return DropdownMenuItem<String>(
                //       value: designation,
                //       child: Text(designation),
                //     );
                //   }).toList(),
                //   onChanged: (value) {
                //     _controller.formData.designation = value!;
                //   },
                //   decoration: InputDecoration(labelText: 'Designation'),
                // ),
                // DropdownButtonFormField<String>(
                //   items: ['IT', 'Finance', 'Healthcare', 'Software Industry']
                //       .map((String industry) {
                //     return DropdownMenuItem<String>(
                //       value: industry,
                //       child: Text(industry),
                //     );
                //   }).toList(),
                //   onChanged: (value) {
                //     _controller.formData.industry = value!;
                //   },
                //   decoration: InputDecoration(labelText: 'Industry'),
                // ),
                // TextFormField(
                //   decoration: InputDecoration(labelText: 'Years of Experience'),
                //   keyboardType: TextInputType.number,
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return 'Please enter your years of experience';
                //     }
                //     return null;
                //   },
                //   onSaved: (value) {
                //     _controller.formData.yearsOfExperience = value!;
                //   },
                // ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickFile,
                  child: Text(_uploadedFilePath == null
                      ? 'Upload CV'
                      : 'CV Selected'),
                ),
                if (_uploadedFilePath != null) ...[
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.attach_file),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _uploadedFilePath!.split('/').last,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
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
