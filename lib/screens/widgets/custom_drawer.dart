import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todogul/screens/edit_profile_screen.dart';
import 'package:todogul/screens/settings_screen.dart';
import 'package:todogul/screens/login_screen.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final supabase = Supabase.instance.client;
  String _username = '';
  String _email = '';
  String _profileImage = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final response = await supabase
          .from('profiles')
          .select('username, profile_image')
          .eq('id', user.id)
          .single();

      setState(() {
        _username = response['username'] ?? 'Guest';
        _email = user.email ?? '';
        _profileImage = response['profile_image'] ?? 'img/default_avatar.png';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              _username,
              style: TextStyle(color: Colors.white),
            ),
            accountEmail: Text(
              _email,
              style: TextStyle(color: Colors.white70),
            ),
            currentAccountPicture: ClipOval(
              child: Image.asset(_profileImage, fit: BoxFit.cover),
            ),
            decoration: BoxDecoration(color: Colors.black),
          ),
          ListTile(
            leading: Icon(Icons.edit, color: Colors.white),
            title: Text(
              'Edit Profile',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
              _loadUserProfile(); // Reload profile data after editing
            },
          ),
          Divider(color: Colors.white24, thickness: 0.5),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text(
              'Settings',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          Divider(color: Colors.white24, thickness: 0.5),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
            child: ListTile(
              leading: Icon(Icons.logout, color: Colors.redAccent),
              title: Text(
                'Log Out',
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.grey[900],
                    title: Text(
                      'Konfirmasi',
                      style: TextStyle(color: Colors.white),
                    ),
                    content: Text(
                      'Apakah Anda yakin ingin keluar?',
                      style: TextStyle(color: Colors.white70),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Batal',
                            style: TextStyle(color: Colors.white)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (route) => false,
                          );
                        },
                        child: Text('Keluar',
                            style: TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
