import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase Core
import 'firebase_options.dart'; // FirebaseOptions'u içe aktar
import 'login_page.dart';
import 'signup_page.dart';
import 'video_call_page.dart';
import 'live_support_page.dart';
import 'normal_signup_page.dart';

void main() async {
  // Firebase'i başlat
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // FirebaseOptions'u kullan
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Deaf World',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/videoCall': (context) => VideoCallPage(),
        '/liveSupport': (context) => LiveSupportPage(),
        '/normalSignup': (context) => NormalSignupPage(),
      },
    );
  }
}