import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:html' as html; // Add this import for Flutter web

import '../../providers/task_provider.dart';
import '../screens/load_page.dart';

class FinalScreen extends StatefulWidget {
  final int correctAnswersCount;
  final int totalQuestions;

  const FinalScreen(
      {Key? key,
      required this.correctAnswersCount,
      required this.totalQuestions})
      : super(key: key);

  @override
  _FinalScreenState createState() => _FinalScreenState();
}

class _FinalScreenState extends State<FinalScreen>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AudioPlayer _audioPlayer;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    _audioPlayer = AudioPlayer();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _opacityAnimation =
        Tween<double>(begin: 0.5, end: 1.0).animate(_controller);

    // Play audio
    _playAudio();

    // Start confetti animation
    _confettiController.play();
  }

  Future<void> _playAudio() async {
    await _audioPlayer.setVolume(0.5); // Adjust volume
    await _audioPlayer.play(AssetSource('images/kids_cheering.mp3'));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _removeIdFromUrl() {
    // Remove the ID from the URL without refreshing the page
    html.window.history
        .pushState(null, '', '/'); // Adjust the URL path to root or as needed
  }

  @override
  Widget build(BuildContext context) {
    final questionProvider =
        Provider.of<QuestionProvider>(context, listen: false);

    // Get screen width and height for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/finalScreen1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: screenWidth * 0.8,
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/pause_board.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Text(
                      'מצאת המטמון!\nנראה אותך במשחק הבא!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'כל הכבוד! הצלחת ב-${widget.correctAnswersCount} מתוך ${widget.totalQuestions} משימות!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  GestureDetector(
                    onTap: () {
                      questionProvider.resetGame();
                      _removeIdFromUrl(); // Remove the ID from the URL
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoadPage()),
                      );
                    },
                    child: Container(
                      width: screenWidth * 0.5,
                      height: screenHeight * 0.06,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/button.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'יציאה',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.1),
                ],
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.04,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/treasure-unscreen1.gif',
                    width: screenWidth * 0.5,
                    height: screenWidth * 0.5,
                  ),
                  Positioned(
                    top: screenHeight * 0.04,
                    left: screenWidth * 0.12,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: Image.asset(
                        'assets/images/sparkle.png',
                        width: screenWidth * 0.12,
                        height: screenWidth * 0.12,
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.06,
                    right: screenWidth * 0.12,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: Image.asset(
                        'assets/images/sparkle.png',
                        width: screenWidth * 0.15,
                        height: screenWidth * 0.15,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: screenHeight * 0.04,
                    left: screenWidth * 0.18,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: Image.asset(
                        'assets/images/sparkle.png',
                        width: screenWidth * 0.1,
                        height: screenWidth * 0.1,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: screenHeight * 0.06,
                    right: screenWidth * 0.18,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: Image.asset(
                        'assets/images/sparkle.png',
                        width: screenWidth * 0.1,
                        height: screenWidth * 0.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: -3.14 / 2,
                maxBlastForce: 20,
                minBlastForce: 8,
                numberOfParticles: 30,
                gravity: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
