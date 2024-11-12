import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'providers/task_provider.dart';
import 'theme/app_theme.dart';
import 'view/screens/init_screen.dart';

List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request microphone permission
  var microphoneStatus = await Permission.microphone.request();
  if (microphoneStatus.isGranted) {
    print("Microphone permission granted.");
  } else {
    print("Microphone permission denied.");
  }

  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => QuestionProvider()..wakeUpService(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Find the treasure',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ar'), // Arabic
          Locale('he'), // Hebrew
        ],
        // Set locale to Hebrew (RTL)
        locale: const Locale('he'),
        theme: MyAppTheme.buildTheme(),
        home: const InitScreen(),

        // Enforce RTL text direction globally
        builder: (context, widget) {
          return Directionality(
            textDirection: TextDirection.rtl, // Set to RTL
            child: widget!,
          );
        },
      ),
    );
  }
}
