import 'package:flutter/material.dart';
import 'onboarding_screen.dart'; 
import 'register_screen.dart'; 
import 'login_screen.dart'; // Ensure this import is included

class StartScreen extends StatelessWidget {
  // Define constants for colors
  static const Color primaryColor = Color(0xFF8875FF);
  static const Color backgroundColor = Colors.black;
  static const Color whiteColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, 
      body: Stack(
        children: [
          // Back Button at the top
          Positioned(
            top: 40,
            left: 16,
            child: GestureDetector(
              onTap: () {
                // Navigate back to OnboardingScreen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => OnboardingScreen()),
                );
              },
              child: Image.asset(
                'img/back_icon.png',
                width: 24,
                height: 24,
              ),
            ),
          ),
          // Main content
          Positioned(
            top: 100, // Adjust position
            left: 16,
            right: 16,
            child: Column(
              children: [
                Text(
                  'Welcome to TodoGul',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor, // Use constant
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Please login to your account or create a new account to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: whiteColor, // Use constant
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Buttons at the bottom
          Positioned(
            bottom: 40,
            left: 16,
            right: 16,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to LoginScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor, // Use constant
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: whiteColor, // Use constant
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {
                    // Navigate to RegisterScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryColor), // Use constant
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          color: primaryColor, // Use constant
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}