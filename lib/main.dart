import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cy_app/video_chat_page.dart' as VideoChat;
import 'package:cy_app/live_support_page.dart' as LiveSupport;
import 'login_page.dart';
import 'signup_page.dart';
import 'normal_signup_page.dart';
import 'home_page.dart';
import 'shopping_page.dart';
import 'services/api_service.dart';
import 'package:cy_app/live_support_page.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Deaf World',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/normalSignup': (context) => NormalSignupPage(),
        '/home': (context) => HomePage(),
        '/shopping': (context) => ShoppingPage(),
        '/videoCall': (context) => VideoChat.VideoChatPage(roomId: 'room123'),
        '/liveSupport': (context) => LiveSupportPage(roomId: 'defaultRoom'),

        '/aiSearch': (context) => AISearchPage(),
      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) => NotFoundPage());
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => NotFoundPage());
      },
    );
  }
}

class NotFoundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sayfa Bulunamadı')),
      body: Center(
        child: Text(
          'Hata: Sayfa bulunamadı! Lütfen tekrar deneyin.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// 📌 Jina AI Destekli Arama Sayfası
class AISearchPage extends StatefulWidget {
  @override
  _AISearchPageState createState() => _AISearchPageState();
}

class _AISearchPageState extends State<AISearchPage> {
  final ApiService apiService = ApiService();
  TextEditingController _queryController = TextEditingController();
  String result = "Sonuç burada görünecek";

  void searchQuery() async {
    setState(() {
      result = "Aranıyor...";
    });

    try {
      String response = await apiService.getJinaResponse(_queryController.text);

      setState(() {
        result = response;
      });
    } catch (e) {
      setState(() {
        result = "Hata: AI yanıtı alınamadı.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Jina AI Arama')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _queryController,
              decoration: InputDecoration(
                labelText: 'Arama sorgunuzu girin',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: searchQuery,
              child: Text("Ara"),
            ),
            SizedBox(height: 20),
            Text(
              result,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}