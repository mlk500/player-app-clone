import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../widgets/camera_viewer.dart';
import 'home_page.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({Key? key});

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35, // Move the button up by decreasing the value
            left: MediaQuery.of(context).size.width * 0.05, // Center horizontally with some margin
            right: MediaQuery.of(context).size.width * 0.05,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(
                              cameraMode: CameraMode.objectFinder),
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/button.png'),
                          fit: BoxFit.cover, // or BoxFit.fill
                        ),
                      ),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            'סרקו קוד משחק',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const HomePage(cameraMode: CameraMode.objectFinder)),
                );
              },
              child: Image.asset(
                'assets/images/island.png',
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
