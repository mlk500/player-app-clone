import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanner extends StatefulWidget {
  final Function(String) onScanComplete;
  final String expectedQRCode;
   String? hint; // Add a hint parameter

   QRScanner({
    super.key,
    required this.onScanComplete,
    required this.expectedQRCode,
     this.hint, // Add this line
  });

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  late MobileScannerController _cameraController;

  @override
  void initState() {
    super.initState();
    _cameraController = MobileScannerController();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _restartCamera() {
    _cameraController.start();
  }

  void _showHintDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hint'),
          content: Text(widget.hint??''),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
                _restartCamera();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _restartCamera();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('חפש מקום'),
          actions: [
            IconButton(
              icon: const Icon(Icons.lightbulb_outline),
              onPressed: () => _showHintDialog(context), // Show hint dialog
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          child: Center(
            child: MobileScanner(
              controller: _cameraController,
              fit: BoxFit.contain,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  final scannedData = barcodes.first.rawValue ?? '';
                  if (scannedData.isNotEmpty) {
                    _cameraController.stop(); // Stop scanning after a successful scan
                    widget.onScanComplete(scannedData);
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
