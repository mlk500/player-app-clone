import 'package:flutter/material.dart';
import 'qr_scaner.dart'; // Adjust the import path if necessary
import 'object_finder.dart';

enum CameraMode {
  qrScanner,
  objectFinder,
}

class CameraViewer extends StatelessWidget {
  final CameraMode cameraMode;
  final Function(String)? onScanComplete; // Callback for when a scan is complete
  final String? expectedQRCode; // Expected QR code for validation

  const CameraViewer({
    super.key,
    required this.cameraMode,
    this.onScanComplete,
    this.expectedQRCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cameraMode == CameraMode.qrScanner
          ? QRScanner(
              onScanComplete: onScanComplete ?? (scannedData) {},
              expectedQRCode: expectedQRCode ?? '',
            )
          : const ObjectFinder(), // You can modify ObjectFinder similarly if needed
    );
  }
}
