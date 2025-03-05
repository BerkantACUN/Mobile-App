import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:google_sign_in/google_sign_in.dart'; 

class LoginPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giriş başarısız: ${e.message}')),
      );
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google ile giriş başarısız: $e')),
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
            _header(),
            _inputField(context),
            _forgotPassword(),
            _signup(context),
            _socialLogin(context),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return const Column(
      children: [
        Text("Hoş Geldiniz",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        Text("Giriş yapmak için bilgilerinizi girin"),
      ],
    );
  }

  Widget _inputField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _emailController,
          decoration: _inputDecoration("E-posta", Icons.email),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          decoration: _inputDecoration("Şifre", Icons.password),
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
          child: const Text("Giriş Yap",
              style: TextStyle(fontSize: 20, color: Colors.white)),
        )
      ],
    );
  }

  InputDecoration _inputDecoration(String hintText, IconData icon) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      fillColor: Colors.purple.withOpacity(0.1),
      filled: true,
      prefixIcon: Icon(icon),
    );
  }

  Widget _forgotPassword() {
    return TextButton(
      onPressed: () {},
      child: const Text("Şifremi Unuttum?",
          style: TextStyle(color: Colors.purple)),
    );
  }

  Widget _signup(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Hesabınız yok mu? "),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/signup'),
          child: const Text("Kayıt Ol", style: TextStyle(color: Colors.purple)),
        ),
      ],
    );
  }

  Widget _socialLogin(BuildContext context) {
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
          ],
        ),
      ],
    );
  }
}
