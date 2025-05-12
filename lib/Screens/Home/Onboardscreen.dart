import 'package:flutter/material.dart';

import '../Authentication/Login_Screen.dart';

class Onboardscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get screen size using MediaQuery
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            height: screenHeight,
            width: screenWidth,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/splashbackgroundimg.png'),
                fit: BoxFit.cover, // Ensures the image covers the entire screen
              ),
            ),
          ),
          // Overlay to darken the image slightly for text readability (optional)
          Container(
            height: screenHeight,
            width: screenWidth,
            color: Colors.black.withOpacity(0.3), // Adjust opacity as needed
          ),
          // Content (Text and Button)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Spacer to push content towards the middle
                SizedBox(height: screenHeight * 0.2),
                // Text: "Hey Budget Boss!!"
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Text(
                    'Hey Budget Boss!!',
                    style: TextStyle(
                      fontSize: screenWidth * 0.08, // Responsive font size
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                // Text: "Ready to plan your trip like a pro?..."
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Text(
                    'Ready to plan your trip like a pro? Let’s make every penny count.',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05, // Responsive font size
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Spacer to push the button towards the bottom
                SizedBox(height: screenHeight * 0.3),
                // Get Started Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to LoginScreen when the button is pressed
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFD4A373), // Button color
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045, // Responsive font size
                          color: Colors.white,
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