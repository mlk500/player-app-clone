import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_player/view/screens/credits.dart';

import '../../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late AnimationController _dotController;
  late List<Animation<double>> _dotAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _dotAnimations = List.generate(3, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _dotController,
          curve: Interval(
            index / 3,
            (index + 1) / 3,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });

    _controller.forward().then((_) {
      Future.delayed(const Duration(seconds: 5), () {
        Navigator.of(context).pushReplacementNamed('/home');
      });
    });

    _dotController.repeat(); // Loop the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    _dotController.dispose();
    super.dispose();
  }

  Widget _buildDot(int index) {
    return FadeTransition(
      opacity: _dotAnimations[index],
      child: const Text(
        '.',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppTheme.buildTheme().hoverColor,
      body: Stack(
        children: [
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(
                Icons.info_outline,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreditsScreen()),
                );
              },
              tooltip: 'View Credits',
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200, // Set a fixed width
                    height: 200, // Set a fixed height
                    child: Image.asset('assets/images/logo_shiba.png'),
                  ),
                  SizedBox(
                    width: 200, // Same width for all images
                    height: 200, // Same height for all images
                    child: Image.asset('assets/images/info.png'),
                  ),
                  SizedBox(
                    width: 200, // Same width for all images
                    height: 200, // Same height for all images
                    child: Image.asset('assets/images/haifa_new.png'),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "כבר מתחילים",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Row(
                      children: List.generate(3, _buildDot),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
