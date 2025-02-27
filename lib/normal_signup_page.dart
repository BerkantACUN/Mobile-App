import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication
import 'package:cloud_firestore/cloud_firestore.dart'; // Cloud Firestore

class NormalSignupPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  Future<void> _signup(BuildContext context) async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Kullanıcı bilgilerini Firestore'a kaydet
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'createdAt': DateTime.now(),
      });

      // Kayıt başarılıysa VideoCallPage'e yönlendir
      Navigator.pushNamed(context, '/videoCall');
    } on FirebaseAuthException catch (e) {
      // Hata durumunda kullanıcıya bilgi ver
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kayıt başarısız: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const SizedBox(height: 60.0),
                  const Text(
                    "Normal Kayıt",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Bilgilerinizi girin",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Adınız",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                      fillColor: Colors.purple.withOpacity(0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
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
                ],
              ),
              ElevatedButton(
                onPressed: () => _signup(context),
                child: const Text(
                  "Kayıt Ol",
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.purple,
                ),
              ),
              const Center(child: Text("Veya")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Zaten bir hesabınız var mı?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: const Text(
                      "Giriş Yap",
                      style: TextStyle(color: Colors.purple),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}