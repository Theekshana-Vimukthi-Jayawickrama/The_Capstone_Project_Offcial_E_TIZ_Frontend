import 'package:e_tiz_conductor_pages/Conductor/Loggin.dart';
import 'package:flutter/material.dart';

class PasswordChangeSucessful extends StatefulWidget {
  const PasswordChangeSucessful({super.key, t});

  @override
  State<PasswordChangeSucessful> createState() =>
      _PasswordChangeSucessfulState();
}

class _PasswordChangeSucessfulState extends State<PasswordChangeSucessful> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Loggin()));
    });
  }

  @override
  Widget build(BuildContext context) {
    //  Future.delayed for navigation after 3 seconds
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text(
              "Successful Update Your password",
              style: TextStyle(color: Color(0xFFFFFFFF)),
            ),
          ),
          backgroundColor: Color(0xFF881C34),
        ),
        body: Stack(
          children: [
            const Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  'Successful!',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 280, bottom: 50),
                  child: Image.asset("assets/success.png"),
                )),
          ],
        ),
      ),
    );
  }
}
