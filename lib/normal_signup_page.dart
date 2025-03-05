import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NormalSignupPage extends StatefulWidget {
  @override
  _NormalSignupPageState createState() => _NormalSignupPageState();
}

class _NormalSignupPageState extends State<NormalSignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Future<void> _signup() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      _showMessage(' Lütfen tüm alanları doldurun!', isError: true);
      return;
    }

    _showLoading();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'name': name,
        'email': email,
        'createdAt': DateTime.now(),
      });

      Navigator.of(context, rootNavigator: true).pop(); 

      _showMessage('✅ Kayıt başarılı! Giriş sayfasına yönlendiriliyorsunuz...');

      await Future.delayed(const Duration(seconds: 2));

      Navigator.pushReplacementNamed(context, '/'); 
    } on FirebaseAuthException catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      _showMessage(' Hata: ${e.message}', isError: true);
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      _showMessage(' Bir hata oluştu: $e', isError: true);
    }
  }

  void _showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            const Text("Normal Kayıt", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Bilgilerinizi girin", style: TextStyle(fontSize: 15, color: Colors.grey[700])),
            const SizedBox(height: 20),

            _buildTextField(controller: _nameController, hint: "Adınız", icon: Icons.person),
            const SizedBox(height: 10),
            _buildTextField(controller: _emailController, hint: "E-posta", icon: Icons.email),
            const SizedBox(height: 10),
            _buildTextField(controller: _passwordController, hint: "Şifre", icon: Icons.lock, isPassword: true),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _signup,
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.purple,
              ),
              child: const Text("Kayıt Ol", style: TextStyle(fontSize: 20, color: Colors.white)),
            ),

            const SizedBox(height: 10),
            const Text("Veya"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Zaten bir hesabınız var mı?"),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                  child: const Text("Giriş Yap", style: TextStyle(color: Colors.purple)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
        fillColor: Colors.purple.withOpacity(0.1),
        filled: true,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
