import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interviewai/common/common_widget.dart';
import 'package:interviewai/form/controller/form_controller.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:image_picker/image_picker.dart';
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

  // Future<void> _pickFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();
  //   if (result != null) {
  //     setState(() {
  //       _uploadedFilePath = result.files.single.path;
  //     });
  //     _extractTextFromPdf(_uploadedFilePath!);
  //   }
  // }

  // Future<bool> _request_per(Permission permission) async {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
  //   if (build.version.sdkInt >= 30) {
  //     // For Android SDK version 30 (Android 11) and above
  //     var re = await Permission.manageExternalStorage.request();
  //     if (re.isGranted) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } else {
  //     // For Android SDK versions below 30
  //     if (await permission.isGranted) {
  //       return true;
  //     } else {
  //       var result = await permission.request();
  //       if (result.isGranted) {
  //         return true;
  //       } else {
  //         return false;
  //       }
  //     }
  //   }
  // }


  Future<bool> checkStoragePermission(BuildContext context) async {
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
      if ((info.version.sdkInt ?? 0) >= 33) {
        return true; // Return true if SDK version is sufficient
      }
    }

    // Request storage permission
    if (!await requestPermission([Permission.storage])) {
      return false; // Return false if permission is not granted
    }

    return true; // Return true if permission is granted
  }

  Future<bool> requestPermission(List<Permission> permissions) async {
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    bool allGranted = statuses.values.every((status) => status.isGranted);
    return allGranted;
  }

  Future<File?> _pickFile(BuildContext context) async {
    // Check storage permission
    bool hasPermission = await checkStoragePermission(context);
    if (!hasPermission) {
      // Handle case where permission is not granted
      print('Storage permission not granted.');
      return null;
    }

    // Pick a PDF file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty && result.files.first.extension == 'pdf') {
      // Return the picked file
      return File(result.files.first.path!);
    } else {
      // Clear temporary files (if any) and return null
      FilePicker.platform.clearTemporaryFiles();
      return null;
    }
  }

  // Future<void> _pickFile() async {
  //   try {
  //     if (Platform.isAndroid) {
  //       if (int.parse(Platform.version.split('.').first) >= 13) {
  //         FilePickerResult? result = await FilePicker.platform.pickFiles();
  //         if (result != null) {
  //           setState(() {
  //             _uploadedFilePath = result.files.single.path;
  //           });
  //           _extractTextFromPdf(_uploadedFilePath!);
  //         }
  //       } else {
  //         FilePickerResult? result = await FilePicker.platform.pickFiles();
  //         if (result != null) {
  //           setState(() {
  //             _uploadedFilePath = result.files.single.path;
  //           });
  //           _extractTextFromPdf(_uploadedFilePath!);
  //         }
  //       }
  //     } else {
  //       FilePickerResult? result = await FilePicker.platform.pickFiles();
  //       if (result != null) {
  //         setState(() {
  //           _uploadedFilePath = result.files.single.path;
  //         });
  //         _extractTextFromPdf(_uploadedFilePath!);
  //       }
  //     }
  //   } on PlatformException catch (e) {
  //     print('Error picking file: $e');
  //   }
  // }



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
        title: Text('Hi! $username', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10,vertical:10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.tealAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage('assets/images/guide.png'), // Replace with your image path
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          'Hi! $username, I am Kirti your Guide for Mock Interview',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
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
                  Text(
                    'Please upload your CV to Start AI Mock Interview',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black38),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () async {
                      File? pickedFile = await _pickFile(context);
                      if (pickedFile != null) {
                        setState(() {
                          _uploadedFilePath = pickedFile.path;
                        });
                        if (pickedFile.path.endsWith('.pdf')) {
                          await _extractTextFromPdf(pickedFile.path);
                        }
                      }
                    },
                    icon: Icon(Icons.upload_file, color: Colors.teal),
                    label: Text(
                      _uploadedFilePath == null ? 'Upload CV PDF' : 'CV Selected',
                      style: TextStyle(color: Colors.teal),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      textStyle: TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  if (_uploadedFilePath != null) ...[
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.attach_file, color: Colors.white),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _uploadedFilePath!.split('/').last,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: 20),
                  Center(
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : CommonWidget(
                      text: 'Ready to Start Interview',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() {
                            _isLoading = true;
                          });
                          _controller.submitForm(id).then((_) {
                            setState(() {
                              _isLoading = false;
                            });
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: _onItemTapped,
      ),
    );
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
      // Handle Home tab
        break;
      case 1:
      // Handle Quiz tab
        break;
      case 2:
      // Handle Profile tab
        break;
    }
  }
}
  //   );
  // }



// }
