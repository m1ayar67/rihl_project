import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rihl/core/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showLogo = false;

  Timer? _logoTimer;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _logoTimer = Timer(
      const Duration(milliseconds: 400),
      () {
        if (!mounted) return;

        setState(() {
          _showLogo = true;
        });
      },
    );

    _navigationTimer = Timer(
      const Duration(milliseconds: 2500),
      () {
        if (!mounted) return;

        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.roleSelection,
          (route) => false,
        );
      },
    );
  }

  @override
  void dispose() {
    _logoTimer?.cancel();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F0),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/rihl_background.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: AnimatedOpacity(
              opacity: _showLogo ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              child: Image.asset(
                'assets/images/rihl_branding.png',
                width: MediaQuery.of(context).size.width * 0.80,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}