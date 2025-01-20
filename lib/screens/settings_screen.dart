import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  // Fungsi untuk menyimpan perubahan
  void _saveChanges() async {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.scale,
        title: 'Oops!',
        desc: 'Password baru dan konfirmasi tidak cocok.',
        btnOkColor: Colors.orange,
        btnOkText: 'Mengerti',
      ).show();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.scale,
          title: 'Error',
          desc: 'User tidak ditemukan.',
          btnOkColor: Colors.red,
          btnOkText: 'Tutup',
        ).show();
        return;
      }

      // Re-authenticate user with current password
      final response = await supabase.auth.signInWithPassword(
        email: user.email!,
        password: currentPassword,
      );

      if (response.user == null) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.scale,
          title: 'Gagal',
          desc: 'Password saat ini salah.',
          btnOkColor: Colors.red,
          btnOkText: 'Coba Lagi',
        ).show();
        return;
      }

      // Update password
      await supabase.auth.updateUser(UserAttributes(password: newPassword));

      // Refresh session to ensure continuity after password change
      await supabase.auth.refreshSession();

      // Show success dialog
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Berhasil',
        desc: 'Password berhasil diubah.',
        btnOkText: 'Kembali',
        btnOkColor: Colors.green,
        btnOkOnPress: () {
          Navigator.pushReplacementNamed(context, '/custom_drawer');
        },
      ).show();

      // Clear input fields
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'Kesalahan',
        desc: 'Password yang Anda masukkan salah.',
        btnOkColor: Colors.red,
        btnOkText: 'Tutup',
      ).show();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pengaturan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black.withOpacity(0.8),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ganti Password',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildPasswordField(
                'Password Saat Ini', _currentPasswordController),
            SizedBox(height: 20),
            _buildPasswordField('Password Baru', _newPasswordController),
            SizedBox(height: 20),
            _buildPasswordField(
                'Konfirmasi Password Baru', _confirmPasswordController),
            SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8687E7),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Simpan Perubahan',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk membuat TextField password
  Widget _buildPasswordField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: true,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.grey[850],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(Icons.lock, color: Colors.white70),
      ),
    );
  }
}
