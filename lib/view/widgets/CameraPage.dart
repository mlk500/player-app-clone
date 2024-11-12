import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_player/utils/ApiUrls.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../providers/task_provider.dart';
import '../screens/template_game.dart';
import 'FinalScreen.dart';
import 'HintDisplay.dart';
import 'question.dart';

class CameraPage extends StatefulWidget {
  final int unitIndex;
  final String? hint;

  const CameraPage({super.key, required this.unitIndex, this.hint});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isUploading = false;
  final String? wakeup = '${ApiUrls.modelServiceAPI}/predict';
  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      ),
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showHintDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hint'),
          content: Text(widget.hint ?? ""),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final questionProvider = Provider.of<QuestionProvider>(context);
    return Scaffold(
      extendBodyBehindAppBar:
          true, // Allows camera preview to extend under the AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'חפש חפץ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline, color: Colors.white),
            onPressed: () => _showHintDialog(context),
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child: CameraPreview(_controller),
                ),
                if (_isUploading)
                  const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.black45,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _isUploading
                            ? null
                            : () async {
                                setState(() {
                                  _isUploading = true;
                                });

                                try {
                                  await _initializeControllerFuture;

                                  final image = await _controller.takePicture();
                                  await _uploadAndValidatePhoto(
                                      image.path, context);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Failed to capture image.')),
                                  );
                                } finally {
                                  setState(() {
                                    _isUploading = false;
                                  });
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 24),
                          backgroundColor: Colors.white.withOpacity(0.8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Text(
                          'מצאתי!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
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
                          } // Go back after skipping
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 24),
                          backgroundColor: Colors.red.withOpacity(0.8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Text(
                          'דלג',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<void> _uploadAndValidatePhoto(
      String filePath, BuildContext context) async {
    try {
      final bytes =
          await _controller.takePicture().then((file) => file.readAsBytes());

      final uri = Uri.parse('$wakeup');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: path.basename(filePath),
        ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);

        final objectName = Provider.of<QuestionProvider>(context, listen: false)
            .units[widget.unitIndex]
            .objectDTO
            .name;
        if (jsonResponse['keras_result'] == objectName) {
          _showCorrectObjectDialog(context, 'חפץ נכון');
        } else {
          _showIncorrectObjectDialog(context, 'חפץ לא נכון');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Image upload failed. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during the upload.')),
      );
    }
  }

  void _showCorrectObjectDialog(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildDialog(
          context: context,
          text: msg,
          image: 'assets/images/avatar.png',
          onContinue: () {
            Navigator.of(context).pop(); // Close the dialog
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Question(unitIndex: widget.unitIndex),
              ),
            );
          },
          msg: 'תודה',
        );
      },
    );
  }

  void _showIncorrectObjectDialog(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildDialog(
          context: context,
          text: msg,
          image: 'assets/images/sadAvatar.png',
          onContinue: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          msg: 'נסה שוב',
        );
      },
    );
  }

  Widget _buildDialog({
    required BuildContext context,
    required String text,
    required VoidCallback onContinue,
    String? msg,
    required String image,
  }) {
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
                    child: Text(
                      msg ?? '',
                      style: const TextStyle(
                        fontSize: 20,
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
}
