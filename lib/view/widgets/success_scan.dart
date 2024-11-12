import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../screens/template_game.dart';

class SuccessScan extends StatelessWidget {
  final String text;

  const SuccessScan({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = MyAppTheme.buildTheme();
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background Template
   
          
          // Semi-transparent overlay to highlight the dialog
        
          
          // Centered Content
          Center(
            child: Container(
              width: screenSize.width * 0.8,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: theme.cardColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Avatar Image
                  Image.asset(
                    'assets/images/avatar.png',
                    width: screenSize.width * 0.4,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  // Display Text
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.hintColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Play Button
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 15.0,
                      ),
                    ),
                    child:const Text(
                      'המשך',
                      style: TextStyle(
                        fontSize: 20,
                        color:Colors.brown,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
