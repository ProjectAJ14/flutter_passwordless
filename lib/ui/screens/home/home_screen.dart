import 'package:flutter/material.dart';
import 'package:flutter_passwordless/data/services/auth/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  String get _username => auth.userName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/icons/white_icon.png',
                  width: 200,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Welcome\n$_username',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: auth.signOut,
                child: const Text("Sign Out"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
