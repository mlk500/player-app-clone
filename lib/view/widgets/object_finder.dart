import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import './HintDisplay.dart';

class ObjectFinder extends StatefulWidget {
  const ObjectFinder({super.key});

  @override
  _ObjectFinderState createState() => _ObjectFinderState();
}

class _ObjectFinderState extends State<ObjectFinder> {
  late MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
    String? _extractIdFromLink(String url) {
    Uri uri = Uri.parse(url);
    List<String> pathSegments = uri.pathSegments;
    if (pathSegments.isNotEmpty) {
      return pathSegments.last; // Get the last segment as the ID
    }
    return null; // Return null if no ID is found
  }

Future<void> handleBarcode(String barcode, BuildContext context) async {
  final decodedBarcode = utf8.decode(barcode.runes.toList());
  final questionProvider = Provider.of<QuestionProvider>(context, listen: false);
String? id=_extractIdFromLink(barcode);
  // Fetch tasks using the QR code's URL
  await questionProvider.fetchTasksFromQRCode(id??'');

  // Check if the units list is not empty before navigating
  if (questionProvider.units.isNotEmpty) {
    // Dispose of the camera controller only when navigating
    _controller.dispose();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
             HintDisplay(unitIndex: 0,previousLocationImageUrl:questionProvider.units.first.locationDTO.qrcodePublicUrl), // Pass the first unit index
      ),
    );
  } else {
    // Show an error alert dialog instead of a snack bar
    showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Stack(
            children: [
              // Semi-transparent background
             
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
                        'assets/images/sadAvatar.png',
                        width: MediaQuery.of(context).size.width * 0.4,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'משחק לא נכון נסה שוב :)',
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
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
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
                          'נסה שוב',
                          style: TextStyle(
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
      },
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      child: Center(
        child: MobileScanner(
          controller: _controller,
          fit: BoxFit.contain,
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            if (barcodes.isNotEmpty) {
              final barcode = barcodes.first.rawValue ?? '';
              if (barcode.isNotEmpty) {
                handleBarcode(barcode, context);
              }
            }
          },
        ),
      ),
    );
  }
}
