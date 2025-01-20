import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final supabase = Supabase.instance.client;
  TextEditingController _usernameController = TextEditingController();
  String _profileImage = ''; // Placeholder for profile image
  String _currentEmail = '';
  String _currentUsername = '';
  List<String> _avatarOptions = [
    'img/avatar1.png', // Path to avatar images
    'img/avatar2.png',
    'img/avatar3.png',
    'img/avatar4.png',
    'img/avatar5.png',
  ];
  String _selectedAvatar = ''; // Default selected avatar

  bool _isEditingImage = false; // Toggle for image editing mode
  bool _isAvatarSelectionVisible =
      false; // Toggle for avatar options visibility

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Load profile data (email, username, profile image URL) from Supabase
  Future<void> _loadProfile() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final response = await supabase
          .from('profiles')
          .select('username, profile_image')
          .eq('id', user.id)
          .single();
      setState(() {
        _currentEmail = user.email ?? '';
        _currentUsername = response['username'] ?? '';
        _selectedAvatar = response['profile_image'] ?? '';
        _usernameController.text = _currentUsername;
      });
    }
  }

  // Save profile changes to Supabase
  Future<void> _saveProfile() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      await supabase.from('profiles').upsert({
        'id': user.id,
        'username': _usernameController.text,
        'profile_image': _selectedAvatar, // Save selected avatar
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.pop(context); // Close the screen after saving
    }
  }

  // Update selected avatar
  void _updateAvatar(String avatarPath) {
    setState(() {
      _selectedAvatar = avatarPath;
      _isAvatarSelectionVisible = false; // Hide avatar options after selection
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black.withOpacity(0.8),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isAvatarSelectionVisible = !_isAvatarSelectionVisible;
                });
              },
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[700],
                backgroundImage: _selectedAvatar.isNotEmpty
                    ? AssetImage(_selectedAvatar) // Display selected avatar
                    : null,
                child: _selectedAvatar.isEmpty
                    ? Icon(Icons.add_a_photo,
                        color: Colors.white) // Placeholder icon
                    : null,
              ),
            ),
            if (_isAvatarSelectionVisible) // Show avatar options if selected
              Column(
                children: [
                  SizedBox(height: 20),
                  Text('Select Avatar:',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _avatarOptions.map((avatar) {
                      return GestureDetector(
                        onTap: () => _updateAvatar(avatar),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(avatar),
                          backgroundColor: Colors.transparent,
                          child: _selectedAvatar == avatar
                              ? Icon(Icons.check_circle, color: Colors.green)
                              : Container(),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            SizedBox(height: 30),
            Text('Email: $_currentEmail',
                style: TextStyle(fontSize: 18, color: Colors.white)),
            SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text(
                'Save Changes',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8687E7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
