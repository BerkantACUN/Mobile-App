import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

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
                    "Kayıt Ol",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Hesabınızı oluşturun",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/normalSignup');
                    },
                    child: const Text("Normal Kayıt"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/liveSupport');
                    },
                    child: const Text("Canlı Destek ile Kayıt"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
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