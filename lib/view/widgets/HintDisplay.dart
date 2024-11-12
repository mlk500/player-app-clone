import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import '../screens/template_game.dart';
import 'CameraPage.dart';
import 'qr_scaner.dart';

class HintDisplay extends StatelessWidget {
  final int unitIndex;
  final String? previousLocationImageUrl;

  const HintDisplay({
    super.key,
    required this.unitIndex,
    required this.previousLocationImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final questionProvider =
        Provider.of<QuestionProvider>(context, listen: false);
    final unit = questionProvider.units[unitIndex];

    // Check if all units have the same qrcodePublicUrl
    final bool allQrCodesSame = questionProvider.units
        .every((u) => u.locationDTO.qrcodePublicUrl == questionProvider.units[0].locationDTO.qrcodePublicUrl);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hint'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                unit.hint,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  // Skip QR scanning if all QR codes are the same or if previousLocationImageUrl matches
                  if (allQrCodesSame ||
                      (previousLocationImageUrl != null &&
                          previousLocationImageUrl ==
                              unit.locationDTO.qrcodePublicUrl &&
                          unitIndex != 0)) {
                    // Move directly to object search (skip QR scan)
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraPage(
                          unitIndex: unitIndex,
                          hint: unit.hint,
                        ),
                      ),
                    );
                  } else {
                    // Proceed to QR Scanner if not all QR codes are the same
                    final scannedData = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QRScanner(
                          onScanComplete: (scannedData) {
                            Navigator.pop(context, scannedData);
                          },
                          expectedQRCode: unit.locationDTO.qrcodePublicUrl,
                          hint: unit.hint, // Pass the hint to the QRScanner
                        ),
                      ),
                    );

                    if (scannedData != null) {
                      _handleSecondScan(scannedData, context, unit.hint);
                    }
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/button.png',
                      width: 270,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      allQrCodesSame ||
                              (previousLocationImageUrl != null &&
                                  previousLocationImageUrl ==
                                      unit.locationDTO.qrcodePublicUrl &&
                                  unitIndex != 0)
                          ? 'לחצו כאן לחיפוש חפץ'
                          : 'לחצו כאן לסריקת קוד המיקום',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 2.0,
                            color: Colors.black38,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSecondScan(
      String scannedData, BuildContext context, String hint) {
    final questionProvider =
        Provider.of<QuestionProvider>(context, listen: false);
    final unit = questionProvider.units[unitIndex];

    final String firstLine = scannedData.split('\n').first.trim();

    if (firstLine == unit.locationDTO.locationID.toString()) {
      // Correct scan
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return _buildDialog(
            context: context,
            text: 'חדר נכון',
            image: 'assets/images/avatar.png',
            onContinue: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraPage(
                    unitIndex: unitIndex,
                    hint: hint,
                  ),
                ),
              );
            },
          );
        },
      );
    } else {
      // Incorrect scan
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return _buildDialog(
            context: context,
            text: '!חדר לא נכון',
            image: 'assets/images/sadAvatar.png',
            onContinue: () {
              Navigator.of(context).pop(); // Close dialog
            },
          );
        },
      );
    }
  }

  Widget _buildDialog({
    required BuildContext context,
    required String text,
    required VoidCallback onContinue,
    required String image,
  }) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0, 4),
                  ),
                ],
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
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                      shadows: [
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 3.0,
                          color: Colors.black38,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 15.0,
                      ),
                      elevation: 5.0,
                    ),
                    child: const Text(
                      'המשך',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
