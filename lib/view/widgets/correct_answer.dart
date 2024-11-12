import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../screens/template_game.dart';


class CorrectAnswer extends StatefulWidget {
  const CorrectAnswer({super.key});

  @override
  State<CorrectAnswer> createState() => _CorrectAnswerState();
}

class _CorrectAnswerState extends State<CorrectAnswer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
         
          Positioned(
            bottom: -100,
            right: 30,
            child: Image.asset(
              'assets/images/avatar.png',
              width: 200,
              height: 500,
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) =>
              //           const HomePage(cameraMode: CameraMode.objectFinder)),
              // );
              Navigator.pop(context);
            },
            child: Positioned(
              child: Image.asset(
                'assets/icons/play_fill.png',
                width: MediaQuery.of(context).size.width * 0.9,
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.20,
            right: MediaQuery.of(context).size.width * 0.10,
            top: MediaQuery.of(context).size.height * 0.55,
            child: Center(
              child: Text(
                'תשובה נכונה!',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: MyAppTheme.buildTheme().hintColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
