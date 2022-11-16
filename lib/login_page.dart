import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shazam/provider/provider_music.dart';

class LoginPage extends StatelessWidget {
  LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.topLeft,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/images/background.gif'),
        fit: BoxFit.cover,
      )),
      child: SafeArea(
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Sign In",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              Image.asset('assets/images/logo.png'),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green, // Background color
                          ),
                          onPressed: () {
                            context.read<Provide_Music>().googleLogin();
                          },
                          icon: FaIcon(FontAwesomeIcons.google,
                              color: Colors.white),
                          label: Text("Iniciar con Google",
                              style: TextStyle(color: Colors.white))),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
