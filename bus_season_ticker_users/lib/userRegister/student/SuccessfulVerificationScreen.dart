import 'package:bus_season_ticker_users/userRegister/student/SetUsername&Password.dart';
import 'package:flutter/material.dart';

class SuccessfulVerificationScreen extends StatefulWidget {
  const SuccessfulVerificationScreen({super.key});

  @override
  State<SuccessfulVerificationScreen> createState() =>
      _SuccessfulVerificationScreenState();
}

class _SuccessfulVerificationScreenState
    extends State<SuccessfulVerificationScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => setUsernameAndPassword()));
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
              "Successful Verification",
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
                  'Verification Successful!',
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
