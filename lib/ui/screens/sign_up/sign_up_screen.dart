import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    const imageSize = 286.0;
    final formHeight = (height - imageSize) - 48;
    return Scaffold(
      backgroundColor: const Color(0xFF96D4E1),
      body: Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 24, 0, 24),
              width: imageSize,
              height: imageSize,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/sign_up.png'),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            width: double.infinity,
            height: formHeight,
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  "Just a few quick things to get started",
                  style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF4098AA).withOpacity(0.12),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
