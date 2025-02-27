import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:google_sign_in/google_sign_in.dart'; 
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'; 
import 'package:twitter_login/twitter_login.dart'; 

class LoginPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Giriş başarılıysa VideoCallPage'e yönlendir
      Navigator.pushNamed(context, '/videoCall');
    } on FirebaseAuthException catch (e) {
      // Hata durumunda kullanıcıya bilgi ver
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giriş başarısız: ${e.message}')),
      );
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushNamed(context, '/videoCall');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google ile giriş başarısız: $e')),
      );
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final OAuthCredential credential = FacebookAuthProvider.credential(
          result.accessToken!.token,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        Navigator.pushNamed(context, '/videoCall');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Facebook ile giriş başarısız: ${result.status}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Facebook ile giriş başarısız: $e')),
      );
    }
  }

  Future<void> _signInWithTwitter(BuildContext context) async {
    try {
      final twitterLogin = TwitterLogin(
        apiKey: 'TWITTER_API_KEY',
        apiSecretKey: 'TWITTER_API_SECRET',
        redirectURI: 'twittersdk://',
      );
      final authResult = await twitterLogin.login();
      final OAuthCredential credential = TwitterAuthProvider.credential(
        accessToken: authResult.authToken!,
        secret: authResult.authTokenSecret!,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushNamed(context, '/videoCall');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Twitter ile giriş başarısız: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _header(context),
            _inputField(context),
            _forgotPassword(context),
            _signup(context),
            _socialLogin(context),
          ],
        ),
      ),
    );
  }

  _header(context) {
    return const Column(
      children: [
        Text(
          "Hoş Geldiniz",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Giriş yapmak için bilgilerinizi girin"),
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "E-posta",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none),
            fillColor: Colors.purple.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.email),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Şifre",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none),
            fillColor: Colors.purple.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _login(context),
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.purple,
          ),
          child: const Text(
            "Giriş Yap",
            style: TextStyle(fontSize: 20),
          ),
        )
      ],
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {
        // Şifremi unuttum sayfasına yönlendir
      },
      child: const Text(
        "Şifremi Unuttum?",
        style: TextStyle(color: Colors.purple),
      ),
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Hesabınız yok mu? "),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/signup');
          },
          child: const Text(
            "Kayıt Ol",
            style: TextStyle(color: Colors.purple),
          ),
        ),
      ],
    );
  }

  _socialLogin(context) {
    return Column(
      children: [
        const Text("Veya sosyal medya ile giriş yap"),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Image.asset('assets/google.png', height: 40),
              onPressed: () => _signInWithGoogle(context),
            ),
            IconButton(
              icon: Image.asset('assets/facebook.png', height: 40),
              onPressed: () => _signInWithFacebook(context),
            ),
            IconButton(
              icon: Image.asset('assets/twitter.png', height: 40),
              onPressed: () => _signInWithTwitter(context),
            ),
          ],
        ),
      ],
    );
  }
}