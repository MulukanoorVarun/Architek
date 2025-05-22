import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tripfin/Screens/Components/CustomAppButton.dart';

class BudgetBossScreen extends StatelessWidget {
  final int savings;

  const BudgetBossScreen({Key? key, this.savings = 48000}) : super(key: key);

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
                    'Wow!',
                    style: TextStyle(
                      fontFamily: 'Mullish',
                      color: Color(0xFFDDA25F), // Orange color (matches image)
                      fontSize: 32, // Matches the size in the image
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4), // Exact spacing as in the image
                  // Subtitle: "You are with in the budget boss."
                  const Text(
                    'You are with in the budget boss.',
                    style: TextStyle(
                      fontFamily: 'Mullish',
                      color: Colors.white, // White color (matches image)
                      fontSize: 14, // Matches the smaller size in the image
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Exact spacing as in the image
            // Illustration (centered)
            Center(
              child: Image.asset(
                'assets/screen1backimage.png', // Your image asset
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
                      text: 'You saved ',
                      style: TextStyle(
                        color: Colors.white, // White color for "You saved"
                        fontSize: 20,
                        fontFamily: 'Mullish',
                        fontWeight: FontWeight.bold,
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
