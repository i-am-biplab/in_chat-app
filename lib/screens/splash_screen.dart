import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_chat/api/apis.dart';
import 'package:in_chat/main.dart';

import 'package:in_chat/screens/auth/login_screen.dart';
import 'package:in_chat/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      // set status bar to transparent
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            systemNavigationBarColor: Colors.white),
      );
      // exit from full-screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      if (APIs.fireauth.currentUser != null) {
        log('\nUser: ${APIs.fireauth.currentUser}');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: mq.height * .20,
            right: mq.width * .25,
            width: mq.width * .50,
            child: Image.asset("assets/images/In_Chat.png"),
          ),
          Positioned(
            bottom: mq.height * .15,
            width: mq.width,
            child: const Text(
              'Chat worry free',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16, color: Colors.black87, letterSpacing: 2),
            ),
          ),
        ],
      ),
    );
  }
}
