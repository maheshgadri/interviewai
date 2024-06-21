import 'package:http/http.dart' as http;

import 'dart:convert';

import '../../constants/api_consts.dart'; // Import dart:convert to use json.encode

class SignUpController {
  Future<void> signUp(String username, String email, String password) async {
    final url = '$NGROK/signup/signup';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'}, // Add content-type header
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
      }), // Convert the body to JSON format
    );
    if (response.statusCode == 200) {
      // User registered successfully
      print('User registered successfully');
    } else {
      // Registration failed
      final Map<String, dynamic> responseData = json.decode(response.body);
      print('Failed to register user: ${responseData['error']}');
    }
  }
}


