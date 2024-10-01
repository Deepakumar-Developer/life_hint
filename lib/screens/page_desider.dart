import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_hint/screens/my_home_page.dart';
import 'package:notes_hint/screens/sign_or_log_page.dart';

class PageGate extends StatelessWidget {
  const PageGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MyHomePage();
          } else {
            return const SignOrLogInPage();
          }
        },
      ),
    );
  }
}
