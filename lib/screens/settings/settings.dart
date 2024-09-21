import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background with gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF17203A),
                  Color.fromRGBO(255, 255, 255, 0.898),
                ],
              ),
            ),
          ),
          const Center(
            child: Text(
              'Settings Page',
              style: TextStyle(fontSize: 20.0), // Adjust font size as needed
            ),
          ),
        ],
      ),
    );
  }
}
