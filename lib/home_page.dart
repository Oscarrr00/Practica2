import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shazam/login_page.dart';
import 'package:shazam/main_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return MainPage(context2: context);
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Algo salio mal"),
                );
              } else {
                return LoginPage();
              }
            }));
  }
}
