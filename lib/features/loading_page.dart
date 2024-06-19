import 'dart:async';
import 'package:flutter/material.dart';
import 'package:diploma/features/home_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  static const int _loadingDurationSeconds = 3;

  @override
  void initState() {
    super.initState();
    _redirectToHomePage();
  }

  void _redirectToHomePage() {
    Timer(
      const Duration(seconds: _loadingDurationSeconds),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/images/loading-logo.png',
              fit: BoxFit.cover,
              width: 498,
              height: 373,
            ),
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Color.fromRGBO(143, 100, 73, 1),
            ),
            backgroundColor: Colors.transparent,
            strokeWidth: 4,
          ),
        ],
      ),
    );
  }
}
