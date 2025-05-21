import 'package:flutter/material.dart';

class FinishTripScreen extends StatelessWidget {
  final int amountSaved;

  const FinishTripScreen({super.key, required this.amountSaved});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1c3132),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Wow!',
                style: TextStyle(
                  color: Color(0xFFF6A85A),
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'You are within the budget boss.',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(height: 40),
            Image.asset(
              'assets/screen1backimage.png',
            ), // Update this asset path
            const SizedBox(height: 50),
            RichText(
              text: TextSpan(
                text: 'You saved ',
                style: const TextStyle(color: Colors.white, fontSize: 20),
                children: [
                  TextSpan(
                    text: '₹$amountSaved',
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 56,
              width: 361,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF6A85A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  // Add your navigation logic here
                },
                child: const Text(
                  'Done',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
