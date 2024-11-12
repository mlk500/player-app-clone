import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../model/task_model.dart';
import '../../providers/task_provider.dart';
import '../screens/template_game.dart';
import 'HintDisplay.dart';
import 'FinalScreen.dart';
import 'MediaWidget.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Question extends StatefulWidget {
  final int unitIndex;

  const Question({super.key, required this.unitIndex});

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  String selectedAnswer = '';
  bool answerSelected = false;
  String correctAnswer = '';
  bool isHintDialogVisible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final questionProvider =
        Provider.of<QuestionProvider>(context, listen: false);
    final currentTask = questionProvider.units[widget.unitIndex].taskDTO;
    if (currentTask.questionTask != null) {
      correctAnswer = currentTask
          .questionTask!.answers[currentTask.questionTask!.correctAnswer];
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionProvider = Provider.of<QuestionProvider>(context);
    final currentTask = questionProvider.units[widget.unitIndex].taskDTO;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: buildContent(questionProvider, currentTask),
    );
  }

  Future<void> handleAnswerSubmission(QuestionProvider questionProvider,
      Task currentTask, bool withMessage) async {
    setState(() {
      answerSelected = true;
    });

    bool isCorrect =
        selectedAnswer == correctAnswer || currentTask.questionTask == null;

    if (isCorrect) {
      questionProvider.incrementCorrectAnswers();
    }

    if (withMessage) {
      // Show answer dialog
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return _buildDialog(
            context: context,
            text: isCorrect ? 'תשובה נכונה' : 'תשובה שגויה',
            image: isCorrect
                ? 'assets/images/avatar.png'
                : 'assets/images/sadAvatar.png',
            onContinue: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
    }

    if (isCorrect) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (questionProvider.isLastUnit(widget.unitIndex)) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FinalScreen(
              correctAnswersCount: questionProvider.correctAnswersCount,
              totalQuestions: questionProvider.units.length,
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HintDisplay(
                unitIndex: widget.unitIndex + 1,
                previousLocationImageUrl:
                    questionProvider.units.first.locationDTO.qrcodePublicUrl),
          ),
        );
      }
    } else {
      resetSelection(questionProvider);
    }
  }

  Widget _buildDialog(
      {required BuildContext context,
      required String text,
      required VoidCallback onContinue,
      required String image}) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: Stack(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    image,
                    width: MediaQuery.of(context).size.width * 0.4,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 15.0,
                      ),
                    ),
                    child: const Text(
                      'המשך',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.brown,
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
Widget buildContent2(QuestionProvider questionProvider, Task currentTask) {
  return Stack(
    alignment: Alignment.topCenter,
    children: [
      Positioned.fill(
        child: Image.asset(
          'assets/images/question_label.png',
          fit: BoxFit.cover,
        ),
      ),
      const TemplateGameScreen(),

      Padding(
        padding: currentTask.mediaList.isNotEmpty
            ? const EdgeInsets.only(top: 85)
            : const EdgeInsets.only(top: 150),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (currentTask.taskFreeTexts.isNotEmpty)
                ...currentTask.taskFreeTexts.map(
                  (text) => Center(
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                ),
              if (currentTask.mediaList.isNotEmpty)
                Wrap(
                  alignment: WrapAlignment.center,
                  children: currentTask.mediaList
                      .map((media) => MediaWidget(media: media))
                      .toList(),
                ),
              if (currentTask.questionTask != null)
                Center(
                  child: Text(
                    currentTask.questionTask!.question,
                    style: GoogleFonts.alef(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.brown,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              if (currentTask.questionTask != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: buildAnswerButtons(currentTask.questionTask!.answers),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: selectedAnswer.isNotEmpty ||
                            currentTask.questionTask == null
                        ? 1.0
                        : 0.6,
                    child: buildButton(
                      key: const Key('check_answer_button'),
                      buttonText: 'סיימתי',
                      imagePath: 'assets/images/answerwood.png',
                      onPressed: () async {
                        if (selectedAnswer.isNotEmpty ||
                            currentTask.questionTask == null) {
                          await handleAnswerSubmission(questionProvider,
                              currentTask, currentTask.withMsg);
                        }
                      },
                      isSelected: selectedAnswer.isNotEmpty ||
                          currentTask.questionTask == null,
                    ),
                  ),
                  const SizedBox(width: 20),
                  buildButton(
                    key: const Key('skip_unit_button'),
                    buttonText: 'דלג שאלה',
                    imagePath: 'assets/images/bottom_borad.png',
                    onPressed: () {
                      if (questionProvider.isLastUnit(widget.unitIndex)) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FinalScreen(
                              correctAnswersCount:
                                  questionProvider.correctAnswersCount,
                              totalQuestions: questionProvider.units.length,
                            ),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HintDisplay(
                              unitIndex: widget.unitIndex + 1,
                              previousLocationImageUrl: questionProvider
                                  .units.first.locationDTO.qrcodePublicUrl,
                            ),
                          ),
                        );
                      }
                    },
                    isSelected: true,
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    ],
  );
}
  void selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      answerSelected = false;
    });
  }

  void resetSelection(QuestionProvider questionProvider) {
    setState(() {
      selectedAnswer = '';
      answerSelected = false;
      final currentTask = questionProvider.units[widget.unitIndex].taskDTO;
      if (currentTask.questionTask != null) {
        correctAnswer = currentTask
            .questionTask!.answers[currentTask.questionTask!.correctAnswer];
      }
    });
  }
  List<Widget> buildAnswerButtons(List<String> answers) {
  return answers.map((answer) {
    int index = answers.indexOf(answer);
    return Padding(
      padding:const EdgeInsets.only(top: 10), // Remove padding for no vertical space
      child: buildAnswerButton(answer, index),
    );
  }).toList();
}

Widget buildAnswerButton(String answer, int index) {
  return buildButton(
    key: Key('answer_button_$index'),
    buttonText: answer,
    imagePath: 'assets/images/answerwood.png',
    isSelected: selectedAnswer == answer,
    onPressed: () {
      selectAnswer(answer);
    },
  );
}
Widget buildButton({
  required String buttonText,
  required String imagePath,
  required VoidCallback onPressed,
  required bool isSelected,
  required Key key,
}) {
  return InkWell(
    key: key,
    onTap: onPressed,
    child: Opacity(
      opacity: isSelected ? 1.0 : 0.6,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9, // 90% of the screen width
        height: MediaQuery.of(context).size.width * 0.13,
        padding: const EdgeInsets.symmetric(vertical: 5.0), // Button height padding
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover, // Ensure the background image covers the full container
          ),
        ),
        child: Center(
          child: AutoSizeText(
            buttonText,
            style: GoogleFonts.alef(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 26),
            maxLines: 1,
            minFontSize: 13,
            maxFontSize: 26,
            stepGranularity: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
        ),
      ),
    ),
  );
}


Widget buildContent(QuestionProvider questionProvider, Task currentTask) {
  return Stack(
    alignment: Alignment.topCenter,
    children: [
      Positioned.fill(
        child: Image.asset(
          'assets/images/question_label.png',
          fit: BoxFit.cover,
        ),
      ),
      const TemplateGameScreen(),

      Padding(
        padding: currentTask.mediaList.isNotEmpty
            ? const EdgeInsets.only(top: 85)
            : const EdgeInsets.only(top: 150),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (currentTask.taskFreeTexts.isNotEmpty)
                ...currentTask.taskFreeTexts.map(
                  (text) => Center(
                    child: AutoSizeText(
            text,
            style: GoogleFonts.alef(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 26),
            maxLines: 3,
            minFontSize: 13,
            maxFontSize: 26,
            stepGranularity: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
                  ),
                ),
              if (currentTask.mediaList.isNotEmpty)
                Wrap(
                  alignment: WrapAlignment.center,
                  children: currentTask.mediaList
                      .map((media) => MediaWidget(media: media))
                      .toList(),
                ),
              if (currentTask.questionTask != null)
                Center(
                  child: Text(
                    currentTask.questionTask!.question,
                    style: GoogleFonts.alef(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.brown,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              if (currentTask.questionTask != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: buildAnswerButtons(currentTask.questionTask!.answers),
                ),
               // Optional space before the submit and skip buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Opacity(
                    opacity: selectedAnswer.isNotEmpty ||
                            currentTask.questionTask == null
                        ? 1.0
                        : 0.6,
                    child: buildButton2(
                      key: const Key('check_answer_button'),
                      buttonText: 'סיימתי',
                      imagePath: 'assets/images/bottom_borad.png',
                      onPressed: () async {
                        if (selectedAnswer.isNotEmpty ||
                            currentTask.questionTask == null) {
                          await handleAnswerSubmission(questionProvider,
                              currentTask, currentTask.withMsg);
                        }
                      },
                      isSelected: selectedAnswer.isNotEmpty ||
                          currentTask.questionTask == null,
                    ),
                  ),
                  const SizedBox(width: 20), // Spacing between submit and skip buttons
                  buildButton2(
                    key: const Key('skip_unit_button'),
                    buttonText: 'דלג שאלה',
                    imagePath: 'assets/images/bottom_borad.png',
                    onPressed: () {
                      if (questionProvider.isLastUnit(widget.unitIndex)) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FinalScreen(
                              correctAnswersCount:
                                  questionProvider.correctAnswersCount,
                              totalQuestions: questionProvider.units.length,
                            ),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HintDisplay(
                              unitIndex: widget.unitIndex + 1,
                              previousLocationImageUrl: questionProvider
                                  .units.first.locationDTO.qrcodePublicUrl,
                            ),
                          ),
                        );
                      }
                    },
                    isSelected: true,
                  ),
                ],
              ),
            //  const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    ],
  );
}
 Widget buildButton2({
    required String buttonText,
    required String imagePath,
    required VoidCallback onPressed,
    required bool isSelected,
    required Key key,
  }) {
    const double buttonSize = 120.0; // Fixed button size

    return InkWell(
      key: key,
      onTap: onPressed,
      child: Stack(
        children: [
          Opacity(
            opacity: isSelected ? 1.0 : 0.6,
            child: Container(
              width: buttonSize,
              height: 60,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.contain,
                ),
              ),
              child: Center(
                child: AutoSizeText(
                  buttonText,
                  style: GoogleFonts.alef(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 22),
                  maxLines: 1, // Limit the text to a single line
                  minFontSize: 13,
                  maxFontSize: 22, // Minimum font size it will shrink to
                  stepGranularity: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible, // No truncation or ellipsis
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}