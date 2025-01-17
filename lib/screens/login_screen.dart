import 'package:flutter/material.dart';
import 'package:todogul/auth/auth_service.dart';
import 'package:todogul/screens/home_screen.dart';
import 'package:todogul/screens/register_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final authService = AuthService();
  bool _isLoading = false;

  void login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.scale,
        title: 'Oops!',
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.orange[700],
        ),
        desc: 'Email dan password tidak boleh kosong!',
        descTextStyle: TextStyle(fontSize: 16),
        btnOkColor: Colors.orange[700],
        buttonsTextStyle: TextStyle(fontSize: 16),
        btnOkText: 'Mengerti',
      ).show();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await authService.signInWithEmailAndPassword(
          email: email, password: password);

      // Show success dialog briefly
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        autoHide: Duration(seconds: 1), // Auto hide after 1 second
        title: 'Login Berhasil',
        desc: 'Selamat datang di Todogul!',
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
      ).show().then((_) {
        // Navigate to home screen after dialog is dismissed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      });
    } catch (e) {
      if (e.toString().contains('Email not confirmed')) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.scale,
          title: 'Email Belum Dikonfirmasi',
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue[700],
          ),
          desc: 'Periksa email Anda untuk konfirmasi.',
          descTextStyle: TextStyle(fontSize: 16),
          btnOkColor: Colors.blue[700],
          btnCancelColor: Colors.grey[400],
          buttonsTextStyle: TextStyle(fontSize: 16),
          btnCancelText: 'Kirim Ulang',
          btnOkText: 'Mengerti',
          btnCancelOnPress: () async {
            await authService.resendConfirmationEmail(email);
            AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.scale,
              title: 'Terkirim',
              titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
              desc: 'Email konfirmasi telah dikirim ulang.',
              descTextStyle: TextStyle(fontSize: 16),
              btnOkColor: Colors.green[700],
              btnOkText: 'Mengerti',
            ).show();
          },
        ).show();
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.scale,
          title: 'Login Gagal',
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.red[700],
          ),
          desc: 'Email atau password salah.\nSilakan coba lagi.',
          descTextStyle: TextStyle(fontSize: 16),
          btnOkColor: Colors.red[700],
          buttonsTextStyle: TextStyle(fontSize: 16),
          btnOkText: 'Mengerti',
        ).show();
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                'img/back_icon.png',
                width: 24,
                height: 24,
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Login',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 40),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF8875FF)),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 30),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF8875FF)),
                ),
              ),
              obscureText: true,
              style: TextStyle(color: Colors.white),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _isLoading ? null : login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8875FF),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.white24,
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'or',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.white24,
                    thickness: 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                // Aksi Login dengan Google
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Color(0xFF8875FF)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'img/google_icon.png',
                    width: 24,
                    height: 24,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Login with Google',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                // Aksi Login dengan Apple
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Color(0xFF8875FF)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'img/apple_icon.png',
                    width: 24,
                    height: 24,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Login with Apple',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(color: Colors.white70),
                  children: [
                    TextSpan(
                      text: 'Register',
                      style: TextStyle(
                        color: Color(0xFF8875FF),
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
