import 'package:flutter/material.dart';

import '../widgets/camera_viewer.dart';
import 'home_page.dart';
import 'load_page.dart';

class HelloPage extends StatelessWidget {
  const HelloPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          InkWell(
            onTap: () {},
            child: Image.asset(
              'assets/images/island.png',
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.bottomCenter,
            ),
          ),
          _buildButton(
            context,
            'מספר משחק',
            () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoadPage(),
                ),
              );
            },
          ),
          _buildButton(
            context,
            'התחל',
            () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(
                    cameraMode: CameraMode.qrScanner,
                  ),
                ),
              );
            },
          ),
              _buildButton(
            context,
            "סרקו קוד התחלה",
            () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(
                    cameraMode: CameraMode.qrScanner,
                  ),
                ),
              );
            },
          ),
          // _buildButton(
          //   context,
          //   "סרקו קוד התחלה",
          //   () {
          //     showDialog(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return AlertDialog(
          //           title: const Text('בחר שפה'),
          //           content: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             children: <Widget>[
          //               TextButton(
          //                 onPressed: () {
          //                   Navigator.pushReplacement(
          //                     context,
          //                     MaterialPageRoute(
          //                       builder: (context) => const HomePage(
          //                         cameraMode: CameraMode.qrScanner,
          //                       ),
          //                     ),
          //                   );
          //                 },
          //                 child: const Text('עברית'),
          //               ),
          //               TextButton(
          //                 onPressed: () {
          //                   Navigator.pushReplacement(
          //                     context,
          //                     MaterialPageRoute(
          //                       builder: (context) => const HomePage(
          //                         cameraMode: CameraMode.qrScanner,
          //                       ),
          //                     ),
          //                   );
          //                 },
          //                 child: const Text('العربية'),
          //               ),
          //             ],
          //           ),
          //         );
          //       },
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return Positioned(
      top: 150 + _buttonIndex(text) * 100,
      left: MediaQuery.of(context).size.width * 0.01,
      right: MediaQuery.of(context).size.width * 0.01,
      child: Align(
        alignment: Alignment.center,
        child: InkWell(
          onTap: onPressed, // Use the provided onPressed callback
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 50,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/button.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  int _buttonIndex(String text) {
    switch (text) {
      case 'מספר משחק':
        return 0;
      case 'התחל':
        return 1;
      case 'סרקו קוד התחלה':
        return 2;
      default:
        return 0;
    }
  }
}
