
import 'dart:convert';

import '../../constants/api_consts.dart';
import '../model/user_profile_model.dart';
import 'package:http/http.dart' as http;

class ProfileController {
  static Future<UserProfile> fetchUserProfile(int id) async {
    final response = await http.post(
      Uri.parse('$NGROK/profile_fetch/profile_fetch'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{'id': id}),
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  static Future<void> updateProfile(int id, String username, String email) async {
    final response = await http.put(
      Uri.parse('$NGROK/profile_update/profile_update/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
      }),
    );

    // if (response.statusCode = 200) {
    //   throw Exception('Failed to update user profile');
    // }
  }
}