import 'package:flutter/material.dart';

import '../controller/profile_controller.dart';
import '../model/user_profile_model.dart';

class ProfilePage extends StatefulWidget {
  final int id;

  ProfilePage({Key? key, required this.id}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile? userProfile;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool _isEditing = false;
  bool _isProfileLoaded = false;
  @override
  void initState() {
    super.initState();
    if (userProfile == null) {
      getUserProfile();
    }
  }

  void getUserProfile() async {
    try {
      UserProfile fetchedProfile = await ProfileController.fetchUserProfile(widget.id);
      setState(() {
        userProfile = fetchedProfile;
        _nameController.text = fetchedProfile.username;
        _emailController.text = fetchedProfile.email;
        _isProfileLoaded = true; // Mark profile as loaded
      });
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }


  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  // void _saveChanges() {
  //   // Implement save functionality here
  //   setState(() {
  //     userProfile!.username = _nameController.text;
  //     userProfile!.email = _emailController.text;
  //     _isEditing = false;
  //   });
  // }
  void _saveChanges() async {
    if (userProfile != null) {
      try {
        await ProfileController.updateProfile(
            widget.id, _nameController.text, _emailController.text);
        setState(() {
          userProfile = UserProfile(
            id: userProfile!.id,
            username: _nameController.text,
            email: _emailController.text,
          );
          _isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        print('Error updating user profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }





  // void _saveChanges() async {
  //   try {
  //     await ProfileController.updateProfile(widget.id, _nameController.text, _emailController.text);
  //     setState(() {
  //       userProfile!.username = _nameController.text;
  //       userProfile!.email = _emailController.text;
  //       _isEditing = false;
  //     });
  //   } catch (e) {
  //     print('Error updating user profile: $e');
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _toggleEditing();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // Replace with your image URL or asset
            ),
            SizedBox(height: 16),
            if (userProfile != null)
              Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            SizedBox(height: 32),
            if (_isEditing)
              ElevatedButton.icon(
                onPressed: _isProfileLoaded ? _saveChanges : null,
                icon: Icon(Icons.save, size: 24),
                label: Text('Save'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )
            ,
          ],
        ),
      ),
    );
  }
}
