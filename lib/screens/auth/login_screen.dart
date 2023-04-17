import 'package:flutter/material.dart';
import 'package:in_chat/main.dart';
import 'package:in_chat/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to In Chat'),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
              top: mq.height * .10,
              right: _isAnimate ? mq.width * .25 : -mq.width,
              width: mq.width * .50,
              duration: const Duration(milliseconds: 1000),
              child: Image.asset("assets/images/In_Chat.png")),
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .05,
            height: mq.height * .07,
            width: mq.width * .90,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade200,
                shape: const StadiumBorder(),
              ),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()));
              },
              icon: Image.asset(
                'assets/images/google.png',
                height: mq.height * .04,
              ),
              label: RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 17),
                  children: [
                    TextSpan(text: 'Login with '),
                    TextSpan(
                        text: 'Google',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
