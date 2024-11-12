import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../widgets/camera_viewer.dart';
import 'template_game.dart';

class HomePage extends StatelessWidget {
  final CameraMode cameraMode;

  const HomePage({super.key, required this.cameraMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const TemplateGameScreen(),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                border: Border.all(
                  color: MyAppTheme.buildTheme().disabledColor,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CameraViewer(cameraMode: cameraMode),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
