import 'package:flutter/material.dart';
import 'package:flash_chat/components/common_button.dart';
import 'package:flash_chat/constants.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email;
  String password;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                email=value;
              },
              decoration:kTextFieldDecoration.copyWith(hintText: 'Enter your E-mail'),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                password=value;
              },
              decoration:kTextFieldDecoration.copyWith(hintText: 'Enter your Password'),
            ),
            SizedBox(
              height: 24.0,
            ),
            CommonButton(
              color: Colors.blueAccent,
              title: 'Register',
              onPressed: () {
                print(email);
                print(password);
              },
            ),
          ],
        ),
      ),
    );
  }
}
