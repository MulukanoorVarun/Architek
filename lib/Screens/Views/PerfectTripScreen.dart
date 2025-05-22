import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Components/CustomAppButton.dart';

class Perfecttripscreen extends StatelessWidget {
  final int savings;

  const Perfecttripscreen({Key? key, this.savings = 48000}) : super(key: key);

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
                    'Perfect Boss !',

                    style: TextStyle(
                      fontFamily: 'Mullish',
                      color: Color(0xFFDDA25F), // Orange color (matches image)
                      fontSize: 32, // Matches the size in the image
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4), // Exact spacing as in the image
                  // Subtitle: "You are with in the budget boss."
                  const Text(
                    'You finished the tour with in the Budget.',
                    style: TextStyle(
                      fontFamily: 'Mullish',
                      fontWeight: FontWeight.w400,
                      color: Colors.white, // White color (matches image)
                      fontSize: 14, // Matches the smaller size in the image
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Exact spacing as in the image

            Center(
              child: Image.asset(
                'assets/screen3backimage.png', // Your image asset
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
                      text: 'You In Perfect ',
                      style: TextStyle(
                        color: Colors.white, // White color for "You saved"
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Mullish',

                      ),
                    ),
                    TextSpan(
                      text: savings
                          .toStringAsFixed(0)
                          .replaceAllMapped(
                            RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                            (Match m) => '${m[1]},',
                          ),
                      style: const TextStyle(
                        color: Color(0xff55EE4A), // Light green for "48,000"
                        fontSize: 24,
                        fontFamily: 'Mullish',
                        fontWeight: FontWeight.w700,
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
