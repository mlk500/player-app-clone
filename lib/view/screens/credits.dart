import 'package:flutter/material.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Credits"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Credits:",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, ),
              textDirection: TextDirection.ltr,
            ),
            const SizedBox(height: 20),
            const Text(
              "Pirate Vectors by Vecteezy:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
               textDirection: TextDirection.ltr,
            ),
            GestureDetector(
              onTap: () {
                // Code to open URL
              },
              child: const Text(
                "https://www.vecteezy.com/free-vector/pirate",
                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                 textDirection: TextDirection.ltr,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Images by Freepik:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
               textDirection: TextDirection.ltr,
            ),
            GestureDetector(
              onTap: () {
                // Code to open URL
              },
              child: const Text(
                "https://www.freepik.com",
                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
