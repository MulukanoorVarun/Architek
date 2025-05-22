import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Components/CustomAppButton.dart';

class Outofbudgetscreen extends StatelessWidget {
  final int savings;

  const Outofbudgetscreen({Key? key, this.savings = 48000}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xff1C3132,
      ), // Dark teal background (matches image)
      body: SafeArea(
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start, // Align content to the left
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15.0,
              ), // Left padding for "Wow!" and subtitle
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hey Budget Boss',
                    style: TextStyle(
                      fontFamily: 'Mullish',
                      color: Color(0xFFffffff), // Orange color (matches image)
                      fontSize: 18, // Matches the size in the image
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4), // Exact spacing as in the image
                  // Subtitle: "You are with in the budget boss."
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Your are',
                            style: TextStyle(
                              color: Colors.white,
                              // White color for "You saved"
                              fontSize: 18,
                              fontFamily: 'Mullish',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'out of budget',
                            style: TextStyle(
                              color: Color(0xffFF3B3B),
                              // White color for "You saved"
                              fontSize: 18,
                              fontFamily: 'Mullish',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Exact spacing as in the image
            // Illustration (centered)
            Center(
              child: Image.asset(
                'assets/screen2backImage.png', // Your image asset
                height: 300, // Matches the size in the image
              ),
            ),
            const SizedBox(height: 10), // Exact spacing as in the image
            // Savings: "You saved 48,000" with split colors
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'You spent more ',
                      style: TextStyle(
                        color: Colors.white, // White color for "You saved"
                        fontSize: 20,
                        fontFamily: 'Mullish',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '2,000 extra  ',
                      style: TextStyle(
                        color: Color(0xffFF4545), // White color for "You saved"
                        fontSize: 20,
                        fontFamily: 'Mullish',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 80, horizontal: 16),
        child: CustomAppButton1(
          text: 'Done',
          onPlusTap: () {
            context.go("/home");
          },
        ),
      ),

    );
  }
}

