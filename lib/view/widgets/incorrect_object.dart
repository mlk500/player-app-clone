import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../screens/template_game.dart';

class IncorrectObject extends StatefulWidget {
  const IncorrectObject({super.key});

  @override
  State<IncorrectObject> createState() => _IncorrectObjectState();
}

class _IncorrectObjectState extends State<IncorrectObject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Game screen as background
     
          // Avatar image
          Positioned(
            bottom: -100,
            right: 30,
            child: Image.asset(
              'assets/images/sadAvatar.png',
              width: 200,
              height: 500,
            ),
          ),
          // Hello world text
          Positioned(
            left: MediaQuery.of(context).size.width * 0.20,
            top: MediaQuery.of(context).size.height * 0.55,
            right: MediaQuery.of(context).size.width * 0.10,
            child: Center(
              child: Text(
                "המשימה \nלא נמצאת פה!",
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: MyAppTheme.buildTheme().primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
