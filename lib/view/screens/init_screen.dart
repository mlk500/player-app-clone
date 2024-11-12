import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_player/utils/ApiUrls.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart'; // Only for mobile
import 'dart:async';
import 'dart:html' as html; // Only used for Flutter web
import '../../providers/task_provider.dart';
import '../widgets/HintDisplay.dart';
import 'load_page.dart';
import 'splash.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  String apiUrl = '${ApiUrls.backendServiceAPI}/public/get-game/';
  bool isLoading = true; // Loading indicator
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();

    // Initialize based on platform
    if (kIsWeb) {
      _handleWebLinks(); // Handle deep links on web
    } else {
      _initUniLinks(); // Handle deep links on mobile (iOS/Android)
    }
  }

  // Initialize uni_links to listen for deep links on mobile platforms
  Future<void> _initUniLinks() async {
    try {
      // Handle the link when the app is first opened via deep link
      String? initialLink = await getInitialLink();

      // Wake up the game services, and then proceed
      await _wakeUpAndProceed(initialLink);

      // Listen for subsequent incoming links (for mobile)
      _sub = linkStream.listen((String? link) {
        if (link != null) {
          _handleDeepLink(link);
        }
      }, onError: (err) {
        print('Error listening to incoming links: $err');
      });
    } catch (e) {
      print('Failed to initialize uni_links: $e');
    }
  }

  // Handle deep linking for both web and mobile
  void _handleDeepLink(String? link) {
    if (link != null) {
      String? extractedId = _extractIdFromLink(link);
      if (extractedId != null) {
        _handleQRCode(extractedId);
      }
    }
  }

  // Handle URL deep linking for web platforms
  void _handleWebLinks() {
    // Get the current URL
    Uri uri = Uri.parse(html.window.location.href);

    // Extract the ID from the web URL (assuming the format is `/somepath/{id}`)
    String? extractedId = _extractIdFromLink(uri.toString());

    // Wake up the game services, and then proceed
    _wakeUpAndProceed(extractedId);
  }

  // Wake up the services and then proceed with deep linking or manual open
  Future<void> _wakeUpAndProceed(String? extractedId) async {
    final questionProvider =
        Provider.of<QuestionProvider>(context, listen: false);

    // Ensure that the wake-up service is completed before proceeding
    await questionProvider.wakeUpService();

    if (questionProvider.isWakeUpComplete) {
      // Proceed with handling the deep link or manual open
      if (extractedId != null) {
        _handleQRCode(extractedId);
      } else {
        // No deep link, handle manual app open
        _handleManualAppOpen();
      }
    } else {
      print("Wake-up service did not complete successfully");
    }
  }

  // Extract the ID from the dynamic link
  String? _extractIdFromLink(String url) {
    Uri uri = Uri.parse(url);
    List<String> pathSegments = uri.pathSegments;
    if (pathSegments.isNotEmpty) {
      return pathSegments.last; // Get the last segment as the ID
    }
    return null; // Return null if no ID is found
  }

  // Handle QR Code from link or scanner
  Future<void> _handleQRCode(String qrCodeId) async {
    final questionProvider =
        Provider.of<QuestionProvider>(context, listen: false);

    // Fetch tasks using the QR code's ID (from deep link)
    await questionProvider.fetchTasksFromQRCode('$qrCodeId');

    // Check if the units list is not empty before navigating
    if (questionProvider.units.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HintDisplay(
            unitIndex: 0, // Start from the first unit
            previousLocationImageUrl:
                questionProvider.units.first.locationDTO.qrcodePublicUrl,
          ),
        ),
      );
    } else {
      _showErrorDialog();
    }
  }

  // Handle manual app open (no deep link)
  Future<void> _handleManualAppOpen() async {
    final questionProvider =
        Provider.of<QuestionProvider>(context, listen: false);

    // If wake-up is already complete, proceed to the next screen
    if (questionProvider.isWakeUpComplete) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoadPage()),
      );
    }
  }

  // Show an error dialog if the game data is not found
  void _showErrorDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
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

  @override
  void dispose() {
    _sub?.cancel(); // Clean up the stream subscription (only on mobile)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen(); // Show the splash screen initially
  }
}
