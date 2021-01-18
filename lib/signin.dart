import 'package:flutter/material.dart';
import 'package:ieee_news/fire.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext contet) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to IEEE News!"),
            TextButton(
              child: Text("Sign In"),
              onPressed: () {
                firebaseFunctions.signInWithGoogle();
              },
            ),
          ],
        ),
      ),
    );
  }
}
