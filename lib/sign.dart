import 'package:flutter/material.dart';
import 'package:ieee_news/fire.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Welcome to IEEE News",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            TextButton(
              child: Text("Sign In with Google"),
              onPressed: () {
                newsFirebase.signInWithGoogle();
              },
            ),
          ],
        ),
      ),
    );
  }
}
